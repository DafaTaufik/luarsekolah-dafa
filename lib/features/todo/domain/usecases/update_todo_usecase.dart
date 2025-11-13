import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;
  UpdateTodoUseCase(this.repository);

  Future<TodoEntity> call(String id, TodoEntity todo) {
    return repository.updateTodo(id, todo);
  }
}
