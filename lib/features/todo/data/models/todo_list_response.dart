import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'todo.dart';

class TodoListResponse {
  final List<TodoEntity> todos;
  final int total;
  final int limit;

  TodoListResponse({
    required this.todos,
    required this.total,
    required this.limit,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      todos: (json['todos'] as List)
          .map((todoJson) => Todo.fromJson(todoJson))
          .toList(),
      total: json['total'],
      limit: json['limit'],
    );
  }
}
