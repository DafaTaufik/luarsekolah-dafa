import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';

class DeleteCourseUseCase {
  final ClassRepository repository;
  DeleteCourseUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteCourse(id);
  }
}
