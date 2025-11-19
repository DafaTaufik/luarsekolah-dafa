import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/create_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:luarsekolah/features/todo/domain/usecases/toggle_todo_completion_usecase.dart';

class TodoController extends GetxController {
  // State
  final todos = <TodoEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  // Loading state for individual todo actions
  final togglingTodos = <String>{}.obs;
  final deletingTodos = <String>{}.obs;

  // Dependencies (usecase)
  final GetTodosUseCase _getTodos = Get.find();
  final CreateTodoUseCase _createTodo = Get.find();
  final UpdateTodoUseCase _updateTodo = Get.find();
  final DeleteTodoUseCase _deleteTodo = Get.find();
  final ToggleTodoCompletionUseCase _toggleTodo = Get.find();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final listResponse = await _getTodos.call(limit: 50);
      todos.assignAll(listResponse.todos);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTodo(TodoEntity todo) async {
    try {
      final createdTodo = await _createTodo(todo);
      todos.add(createdTodo);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateTodo(TodoEntity todo) async {
    try {
      final updated = await _updateTodo(todo.id, todo);
      final idx = todos.indexWhere((t) => t.id == todo.id);
      if (idx != -1) todos[idx] = updated;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteTodo(String id) async {
    deletingTodos.add(id);
    try {
      await Future.wait([
        _deleteTodo(id),
        Future.delayed(const Duration(milliseconds: 500)),
      ]);
      todos.removeWhere((t) => t.id == id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      deletingTodos.remove(id);
    }
  }

  Future<void> toggleTodoComplete(String id) async {
    final idx = todos.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    togglingTodos.add(id);
    try {
      // Jalankan toggle dan delay minimum secara paralel
      final results = await Future.wait([
        _toggleTodo(id),
        Future.delayed(const Duration(milliseconds: 500)),
      ]);
      final toggled = results[0] as TodoEntity;
      todos[idx] = toggled;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      togglingTodos.remove(id);
    }
  }
}
