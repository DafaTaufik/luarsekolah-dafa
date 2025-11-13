import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';

class ToggleTodoCompletionUseCase {
  final TodoRepository repository;
  ToggleTodoCompletionUseCase(this.repository);

  Future<TodoEntity> call(String id) {
    return repository.toggleTodoCompletion(id);
  }
}
