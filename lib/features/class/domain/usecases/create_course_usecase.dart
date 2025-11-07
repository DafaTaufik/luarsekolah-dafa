import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';

class CreateCourseUseCase {
  final ClassRepository repository;
  CreateCourseUseCase(this.repository);

  Future<Course> call(CreateCourseRequest request) {
    return repository.createCourse(request);
  }
}
