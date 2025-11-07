import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';

class GetTodoByIdUseCase {
  final TodoRepository repository;
  GetTodoByIdUseCase(this.repository);

  Future<Todo> call(String id) {
    return repository.getTodoById(id);
  }
}
