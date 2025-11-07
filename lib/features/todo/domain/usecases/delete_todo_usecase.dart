import 'package:luarsekolah/features/todo/data/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/delete_response.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;
  DeleteTodoUseCase(this.repository);

  Future<DeleteResponse> call(String id) {
    return repository.deleteTodo(id);
  }
}
