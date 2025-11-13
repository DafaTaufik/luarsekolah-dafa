import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';

class CreateTodoUseCase {
  final TodoRepository repository;
  CreateTodoUseCase(this.repository);

  Future<TodoEntity> call(TodoEntity todo) {
    return repository.createTodo(todo);
  }
}
