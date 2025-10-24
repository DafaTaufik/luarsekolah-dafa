import 'package:dio/dio.dart';
import 'package:luarsekolah/features/todo/models/todo.dart';
import 'package:luarsekolah/features/todo/models/todo_list_response.dart';
import 'package:luarsekolah/features/todo/models/delete_response.dart';
import 'package:luarsekolah/features/todo/models/error_response.dart';

class TodoService {
  final Dio dio;

  TodoService(this.dio);

  /// POST /todos
  Future<Todo> createTodo(Todo todo) async {
    try {
      final response = await dio.post('/todos', data: todo.toJson());
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET /todos
  /// Query params: limit, offset, completed
  Future<TodoListResponse> getTodoList({
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
  Future<Todo> getTodoById(String id) async {
    try {
      final response = await dio.get('/todos/$id');
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT /todos/{id}
  Future<Todo> updateTodo(String id, Todo todo) async {
    try {
      final response = await dio.put('/todos/$id', data: todo.toJson());
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE /todos/{id}
  Future<DeleteResponse> deleteTodo(String id) async {
    try {
      final response = await dio.delete('/todos/$id');
      return DeleteResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH /todos/{id}/toggle
  Future<Todo> toggleTodoCompletion(String id) async {
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
