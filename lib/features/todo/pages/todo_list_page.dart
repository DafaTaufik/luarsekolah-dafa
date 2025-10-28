import 'package:flutter/material.dart';
import 'package:luarsekolah/features/todo/models/todo.dart';
import 'package:luarsekolah/features/todo/pages/add_todo_page.dart';
import 'package:luarsekolah/features/todo/services/todo_service.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/todo/services/dio_client.dart';
import 'package:luarsekolah/features/todo/widgets/todo_card.dart';
import 'package:luarsekolah/features/todo/widgets/todo_loading_state.dart';
import 'package:luarsekolah/features/todo/widgets/todo_error_state.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  bool _isLoading = false;
  String? _errorMessage;
  late final TodoService _todoService;

  @override
  void initState() {
    super.initState();
    _todoService = TodoService(DioClient().dio);
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final listResponse = await _todoService.getTodoList(limit: 50);
      setState(() {
        todos = listResponse.todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo(Todo todo) async {
    try {
      final createdTodo = await _todoService.createTodo(todo);
      setState(() {
        todos.add(createdTodo);
      });
    } catch (e) {
      _showErrorSnackBar('Gagal menambah todo:  ${e.toString()}');
    }
  }

  Future<void> _updateTodo(Todo updatedTodo) async {
    try {
      final result = await _todoService.updateTodo(
        updatedTodo.id!,
        updatedTodo,
      );
      setState(() {
        final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
        if (index != -1) {
          todos[index] = result;
        }
      });
    } catch (e) {
      _showErrorSnackBar('Gagal mengupdate todo: ${e.toString()}');
    }
  }

  Future<void> _deleteTodo(String todoId) async {
    try {
      await _todoService.deleteTodo(todoId);
      setState(() {
        todos.removeWhere((todo) => todo.id == todoId);
      });
    } catch (e) {
      _showErrorSnackBar('Gagal menghapus todo: ${e.toString()}');
    }
  }

  Future<void> _toggleTodoComplete(String todoId) async {
    final index = todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) return;

    try {
      final result = await _todoService.toggleTodoCompletion(todoId);
      setState(() {
        todos[index] = result;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal mengupdate status todo: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Tutup',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.greenDecorative,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const TodoLoadingState()
          : _errorMessage != null
          ? TodoErrorState(message: _errorMessage, onRetry: _loadTodos)
          : todos.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoCard(
                  todo: todo,
                  onEdit: _editTodo,
                  onDelete: _showDeleteDialog,
                  onToggle: todo.id != null
                      ? () => _toggleTodoComplete(todo.id!)
                      : null,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
          if (result != null) {
            await _addTodo(result);
          }
        },
        backgroundColor: AppColors.greenDecorative,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada todo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan tombol + untuk menambah todo baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _editTodo(Todo todo) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage(todo: todo)),
    );
    if (result != null) {
      _updateTodo(result);
    }
  }

  void _showDeleteDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Todo'),
        content: Text('Apakah Anda yakin ingin menghapus "${todo.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (todo.id != null) _deleteTodo(todo.id!);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
