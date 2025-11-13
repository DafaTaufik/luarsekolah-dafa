import 'package:luarsekolah/features/class/services/course_service.dart';
import 'package:luarsekolah/features/class/data/models/models.dart';

class ClassRepository {
  final CourseService courseService;
  ClassRepository(this.courseService);

  Future<CourseListResponse> getCourses({
    int? limit,
    int? offset,
    List<String>? categoryTag,
  }) {
    return courseService.getCourses(
      limit: limit,
      offset: offset,
      categoryTag: categoryTag,
    );
  }

  Future<Course> getCourseById(String id) {
    return courseService.getCourseById(id);
  }

  Future<Course> createCourse(CourseRequest request) {
    return courseService.createCourse(request);
  }

  Future<Course> updateCourse(String id, CourseRequest request) {
    return courseService.updateCourse(id, request);
  }

  Future<void> deleteCourse(String id) {
    return courseService.deleteCourse(id);
  }
}
