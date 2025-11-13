import 'course.dart';

class CourseListResponse {
  final List<Course> courses;
  final int total;

  const CourseListResponse({required this.courses, required this.total});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    return CourseListResponse(
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'courses': courses.map((e) => e.toJson()).toList(), 'total': total};
  }
}
