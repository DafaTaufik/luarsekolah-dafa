import 'package:dio/dio.dart';
import 'package:luarsekolah/features/todo/domain/entities/todo_entity.dart';
import 'package:luarsekolah/features/todo/domain/repositories/todo_repository.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/features/todo/data/models/todo_list_response.dart';
import 'package:luarsekolah/features/todo/data/models/error_response.dart';

class TodoRepositoryImpl implements TodoRepository {
  final Dio dio;

  TodoRepositoryImpl(this.dio);

  /// GET /todos
  /// Query params: limit, offset, completed
  Future<TodoListResponse> getTodos({
    int limit = 10,
    int offset = 0,
    bool? completed,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit, 'offset': offset};

      // Add completed filter if provided
      if (completed != null) {
        queryParams['completed'] = completed;
      }

      final response = await dio.get('/todos', queryParameters: queryParams);
      return TodoListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET /todos/{id}
  Future<TodoEntity> getTodoById(String id) async {
    try {
      final response = await dio.get('/todos/$id');
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /todos
  Future<TodoEntity> createTodo(TodoEntity todo) async {
    try {
      final todoModel = Todo.fromEntity(todo);
      final response = await dio.post('/todos', data: todoModel.toJson());
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT /todos/{id}
  Future<TodoEntity> updateTodo(String id, TodoEntity todo) async {
    try {
      final todoModel = Todo.fromEntity(todo);
      final response = await dio.put('/todos/$id', data: todoModel.toJson());
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE /todos/{id}
  Future<void> deleteTodo(String id) async {
    try {
      await dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH /todos/{id}/toggle
  Future<TodoEntity> toggleTodoCompletion(String id) async {
    try {
      final response = await dio.patch('/todos/$id/toggle');
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Private method to handle DioException errors
  String _handleError(DioException error) {
    if (error.response != null) {
      // Server responded with error
      try {
        final errorResponse = ErrorResponse.fromJson(error.response!.data);
        return errorResponse.message;
      } catch (e) {
        // If parsing fails, return generic message
        return error.response?.data['message'] ??
            'Server error: ${error.response?.statusCode}';
      }
    } else {
      // Network error or timeout
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Server is taking too long to respond.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        default:
          return error.message ?? 'Unknown error occurred';
      }
    }
  }
}
