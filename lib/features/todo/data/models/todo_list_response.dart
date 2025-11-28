import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'todo.dart';

class TodoListResponse {
  final List<TodoEntity> todos;
  final int total;
  final int limit;
  final DocumentSnapshot? lastDocument; // Cursor for pagination
  final bool hasMore; // Flag to indicate if more data is available

  TodoListResponse({
    required this.todos,
    required this.total,
    required this.limit,
    this.lastDocument,
    this.hasMore = false,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      todos: (json['todos'] as List)
          .map((todoJson) => Todo.fromJson(todoJson))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      hasMore: json['hasMore'] ?? false,
    );
  }
}
