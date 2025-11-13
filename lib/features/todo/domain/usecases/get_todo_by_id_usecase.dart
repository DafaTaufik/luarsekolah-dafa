import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';

class GetTodoByIdUseCase {
  final TodoRepository repository;
  GetTodoByIdUseCase(this.repository);

  Future<TodoEntity> call(String id) {
    return repository.getTodoById(id);
  }
}
