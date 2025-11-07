class DeleteResponse {
  final bool success;
  final String id;

  DeleteResponse({required this.success, required this.id});

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(success: json['success'], id: json['id']);
  }
}
