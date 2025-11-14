import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';

class GetTodosUseCase {
  final TodoRepository repository;
  GetTodosUseCase(this.repository);

  Future<TodoListResponse> call({
    int limit = 10,
    int offset = 0,
    bool? completed,
  }) {
    return repository.getTodos(limit: limit, completed: completed);
  }
}
