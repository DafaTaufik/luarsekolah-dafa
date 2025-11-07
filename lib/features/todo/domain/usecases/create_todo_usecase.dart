import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';

class CreateTodoUseCase {
  final TodoRepository repository;
  CreateTodoUseCase(this.repository);

  Future<Todo> call(Todo todo) {
    return repository.createTodo(todo);
  }
}
