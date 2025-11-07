import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';

class ToggleTodoCompletionUseCase {
  final TodoRepository repository;
  ToggleTodoCompletionUseCase(this.repository);

  Future<Todo> call(String id) {
    return repository.toggleTodoCompletion(id);
  }
}
