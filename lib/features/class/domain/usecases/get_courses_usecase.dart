import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';

class GetCoursesUseCase {
  final ClassRepository repository;
  GetCoursesUseCase(this.repository);

  Future<CourseListResponse> call({
    int? limit,
    int? offset,
    List<String>? categoryTag,
  }) {
    return repository.getCourses(
      limit: limit,
      offset: offset,
      categoryTag: categoryTag,
    );
  }
}
