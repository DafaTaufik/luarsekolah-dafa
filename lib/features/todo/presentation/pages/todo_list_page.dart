import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/features/todo/presentation/pages/add_todo_page.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_card.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_loading_state.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_error_state.dart';
import 'package:luarsekolah/features/todo/presentation/controllers/todo_controller.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});
  final TodoController controller = Get.put(TodoController(), permanent: true);

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const TodoLoadingState();
        } else if (controller.errorMessage.value != null) {
          return TodoErrorState(
            message: controller.errorMessage.value,
            onRetry: controller.loadTodos,
          );
        } else if (controller.todos.isEmpty) {
          return _buildEmptyState();
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.todos.length,
            itemBuilder: (context, index) {
              final todo = controller.todos[index];
              return TodoCard(
                todo: todo,
                onEdit: (todo) => _editTodo(context, controller, todo),
                onDelete: (todo) =>
                    _showDeleteDialog(context, controller, todo),
                onToggle: todo.id != null
                    ? () => controller.toggleTodoComplete(todo.id!)
                    : null,
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
          if (result != null) {
            await controller.addTodo(result);
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

  void _editTodo(
    BuildContext context,
    TodoController controller,
    Todo todo,
  ) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage(todo: todo)),
    );
    if (result != null) {
      await controller.updateTodo(result);
    }
  }

  void _showDeleteDialog(
    BuildContext context,
    TodoController controller,
    Todo todo,
  ) {
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
              if (todo.id != null) controller.deleteTodo(todo.id!);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
