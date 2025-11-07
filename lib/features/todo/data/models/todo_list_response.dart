import 'todo.dart';

class TodoListResponse {
  final List<Todo> todos;
  final int total;
  final int limit;
  final int offset;

  TodoListResponse({
    required this.todos,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      todos: (json['todos'] as List)
          .map((todoJson) => Todo.fromJson(todoJson))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}
