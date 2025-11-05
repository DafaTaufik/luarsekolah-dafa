class CourseException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final dynamic data;

  CourseException({
    required this.message,
    this.statusCode,
    this.code,
    this.data,
  });

  @override
  String toString() => message;
}

class CourseNotFoundException extends CourseException {
  CourseNotFoundException({
    required super.message,
    super.statusCode = 404,
    super.code = 'NOT_FOUND',
    super.data,
  });
}

class CourseValidationException extends CourseException {
  CourseValidationException({
    required super.message,
    super.statusCode = 500,
    super.code = 'VALIDATION_FAILED',
    super.data,
  });
}

class CourseNetworkException extends CourseException {
  CourseNetworkException({
    required super.message,
    super.statusCode,
    super.code,
    super.data,
  });
}
