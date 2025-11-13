import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;
  DeleteTodoUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteTodo(id);
  }
}
