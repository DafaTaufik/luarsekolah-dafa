import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/presentation/pages/add_todo_page.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_card.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_loading_state.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_error_state.dart';
import 'package:luarsekolah/features/todo/presentation/controllers/todo_controller.dart';
import 'package:luarsekolah/core/services/local_notification_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final notificationService = LocalNotificationService.instance;
    await notificationService.initialize();

    final hasPermission = await notificationService.checkPermission();
    if (!hasPermission && mounted) {
      await notificationService.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

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
              return Obx(() {
                final isToggling = controller.togglingTodos.contains(todo.id);
                final isDeleting = controller.deletingTodos.contains(todo.id);

                return TodoCard(
                  todo: todo,
                  onEdit: (todo) => _editTodo(controller, todo),
                  onDelete: (todo) => _showDeleteDialog(controller, todo),
                  onToggle: () => controller.toggleTodoComplete(todo.id),
                  isToggling: isToggling,
                  isDeleting: isDeleting,
                );
              });
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to<TodoEntity>(() => const AddTodoPage());
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

  void _editTodo(TodoController controller, TodoEntity todo) async {
    final result = await Get.to<TodoEntity>(() => AddTodoPage(todo: todo));
    if (result != null) {
      await controller.updateTodo(result);
    }
  }

  void _showDeleteDialog(TodoController controller, TodoEntity todo) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Todo'),
        content: Text('Apakah Anda yakin ingin menghapus "${todo.text}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTodo(todo.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
