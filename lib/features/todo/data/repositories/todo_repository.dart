import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';
import 'package:luarsekolah/features/todo/data/models/delete_response.dart';
import 'package:luarsekolah/features/todo/services/todo_service.dart';

class TodoRepository {
  final TodoService todoService;
  TodoRepository(this.todoService);

  Future<TodoListResponse> getTodos({
    int limit = 10,
    int offset = 0,
    bool? completed,
  }) {
    return todoService.getTodoList(
      limit: limit,
      offset: offset,
      completed: completed,
    );
  }

  Future<Todo> getTodoById(String id) {
    return todoService.getTodoById(id);
  }

  Future<Todo> createTodo(Todo todo) {
    return todoService.createTodo(todo);
  }

  Future<Todo> updateTodo(String id, Todo todo) {
    return todoService.updateTodo(id, todo);
  }

  Future<DeleteResponse> deleteTodo(String id) {
    return todoService.deleteTodo(id);
  }

  Future<Todo> toggleTodoCompletion(String id) {
    return todoService.toggleTodoCompletion(id);
  }
}
