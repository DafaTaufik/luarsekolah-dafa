import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';

class UpdateCourseUseCase {
  final ClassRepository repository;
  UpdateCourseUseCase(this.repository);

  Future<Course> call(String id, UpdateCourseRequest request) {
    return repository.updateCourse(id, request);
  }
}
