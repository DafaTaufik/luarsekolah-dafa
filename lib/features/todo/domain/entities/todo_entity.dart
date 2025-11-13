import 'package:flutter/foundation.dart';

@immutable
class TodoEntity {
  const TodoEntity({
    required this.id,
    required this.text,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String text;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoEntity copyWith({
    String? id,
    String? text,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoEntity &&
        other.id == id &&
        other.text == text &&
        other.completed == completed &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(id, text, completed, createdAt, updatedAt);

  @override
  String toString() {
    return 'TodoEntity(id: $id, text: $text, completed: $completed)';
  }
}
