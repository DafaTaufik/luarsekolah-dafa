import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';

class GetCourseByIdUseCase {
  final ClassRepository repository;
  GetCourseByIdUseCase(this.repository);

  Future<Course> call(String id) {
    return repository.getCourseById(id);
  }
}
