import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;
  UpdateTodoUseCase(this.repository);

  Future<Todo> call(String id, Todo todo) {
    return repository.updateTodo(id, todo);
  }
}
