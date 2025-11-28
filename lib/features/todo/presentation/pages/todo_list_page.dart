import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/presentation/pages/add_todo_page.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_card.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_loading_state.dart';
import 'package:luarsekolah/features/todo/presentation/widgets/todo_error_state.dart';
import 'package:luarsekolah/features/todo/presentation/controllers/todo_controller.dart';
import 'package:luarsekolah/core/services/local_notification_service.dart';
import 'package:luarsekolah/core/services/fcm_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Detect when user scrolls to 80% of list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final controller = Get.find<TodoController>();
      if (!controller.isLoadingMore.value && controller.hasMore.value) {
        controller.loadMoreTodos();
      }
    }
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
      body: Column(
        children: [
          // Display, only on debug
          if (kDebugMode) _buildFcmTokenWidget(),
          Expanded(
            child: Obx(() {
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
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      controller.todos.length +
                      1, // +1 for loading/retry indicator
                  itemBuilder: (context, index) {
                    // Show loading/retry indicator at the bottom
                    if (index == controller.todos.length) {
                      return Obx(() {
                        if (controller.isLoadingMore.value) {
                          return _buildLoadMoreIndicator();
                        } else if (controller.loadMoreError.value != null) {
                          return _buildRetryButton(controller);
                        } else if (!controller.hasMore.value) {
                          return const SizedBox.shrink(); // No more data
                        }
                        return const SizedBox.shrink();
                      });
                    }

                    final todo = controller.todos[index];
                    return Obx(() {
                      final isToggling = controller.togglingTodos.contains(
                        todo.id,
                      );
                      final isDeleting = controller.deletingTodos.contains(
                        todo.id,
                      );

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
          ),
        ],
      ),
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

  Widget _buildFcmTokenWidget() {
    final fcmToken = FcmService.instance.token;

    if (fcmToken == null) {
      return const SizedBox.shrink();
    }

    final truncatedToken = fcmToken.length > 20
        ? '${fcmToken.substring(0, 20)}...'
        : fcmToken;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.blue[50],
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'FCM: $truncatedToken',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            onPressed: () => _copyFcmToken(fcmToken),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  void _copyFcmToken(String token) {
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ FCM Token copied to clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            'Loading more todos...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(TodoController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red[300]),
          const SizedBox(height: 12),
          Text(
            'Failed to load more todos',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => controller.loadMoreTodos(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenDecorative,
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
