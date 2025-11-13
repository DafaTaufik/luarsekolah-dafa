import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';

class Todo extends TodoEntity {
  const Todo({
    required super.id,
    required super.text,
    required super.completed,
    required super.createdAt,
    required super.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      text: json['text'] as String,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'completed': completed};
  }

  // Helper to convert TodoEntity to Todo (for repository usage)
  factory Todo.fromEntity(TodoEntity entity) {
    return Todo(
      id: entity.id,
      text: entity.text,
      completed: entity.completed,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
