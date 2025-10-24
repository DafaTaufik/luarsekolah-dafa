class ErrorResponse {
  final bool defined;
  final String code;
  final int status;
  final String message;
  final Map<String, dynamic>? data;

  ErrorResponse({
    required this.defined,
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      defined: json['defined'] as bool? ?? true,
      code: json['code'] as String,
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'ErrorResponse(code: $code, status: $status, message: $message, data: $data)';
  }
}
