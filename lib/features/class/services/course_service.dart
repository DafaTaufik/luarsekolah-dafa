import 'package:dio/dio.dart';
import 'package:luarsekolah/features/class/models/course.dart';
import 'course_exception.dart';
import 'package:luarsekolah/core/services/dio_client.dart';

class CourseService {
  final DioClient _dioClient;

  CourseService(this._dioClient);

  /// Get list of courses with optional filtering
  /// Parameters: [limit]: Number of items per page, [offset]: Number of items to skip, [categoryTag]: List of category tags
  Future<CourseListResponse> getCourses({
    int? limit,
    int? offset,
    List<String>? categoryTag,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      if (categoryTag != null && categoryTag.isNotEmpty) {
        queryParams['categoryTag'] = categoryTag;
      }

      final response = await _dioClient.dio.get(
        '/courses',
        queryParameters: queryParams,
      );

      return CourseListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single course by ID
  ///Parameters: [id]: Course UUID
  Future<Course> getCourseById(String id) async {
    try {
      final response = await _dioClient.dio.get('/course/$id');
      return Course.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create course
  Future<Course> createCourse(CreateCourseRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/courses',
        data: request.toJson(),
      );
      return Course.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update course
  /// Parameters: [id],[request]
  Future<Course> updateCourse(String id, UpdateCourseRequest request) async {
    try {
      final response = await _dioClient.dio.put(
        '/course/$id',
        data: {'data': request.toJson()},
      );
      return Course.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a course
  /// Parameters: [id]: Course UUID
  Future<void> deleteCourse(String id) async {
    try {
      await _dioClient.dio.delete('/course/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to custom exceptions
  CourseException _handleError(DioException error) {
    if (error.response != null) {
      final response = error.response!;
      final statusCode = response.statusCode;
      final data = response.data;

      // Parse error response
      String message = 'An error occurred';
      String? code;
      dynamic errorData;

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
        code = data['code'];
        errorData = data['data'];
      }

      // Return specific exception based on status code
      switch (statusCode) {
        case 404:
          return CourseNotFoundException(
            message: message,
            statusCode: statusCode,
            code: code,
            data: errorData,
          );
        case 500:
          return CourseValidationException(
            message: message,
            statusCode: statusCode,
            code: code,
            data: errorData,
          );
        default:
          return CourseException(
            message: message,
            statusCode: statusCode,
            code: code,
            data: errorData,
          );
      }
    }

    // Handle network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return CourseNetworkException(
        message: 'Connection timeout. Please check your internet connection.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return CourseNetworkException(
        message: 'No internet connection. Please check your network.',
      );
    }

    return CourseNetworkException(
      message: error.message ?? 'Network error occurred',
    );
  }
}
