import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/data/models/models.dart';

class CreateCourseUseCase {
  final ClassRepository repository;
  CreateCourseUseCase(this.repository);

  Future<Course> call(CourseRequest request) {
    return repository.createCourse(request);
  }
}
