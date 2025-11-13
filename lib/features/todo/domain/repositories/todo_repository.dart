import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';

/// Abstract repository interface for Todo operations.
/// Interface defines the contract for todo data operations.
abstract class TodoRepository {
  Future<TodoListResponse> getTodos({
    int limit = 10,
    int offset = 0,
    bool? completed,
  });

  Future<TodoEntity> getTodoById(String id);
  Future<TodoEntity> createTodo(TodoEntity todo);
  Future<TodoEntity> updateTodo(String id, TodoEntity todo);
  Future<void> deleteTodo(String id);
  Future<TodoEntity> toggleTodoCompletion(String id);
}
