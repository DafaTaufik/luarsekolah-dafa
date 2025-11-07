import 'package:get/get.dart';
import 'package:luarsekolah/features/class/services/course_service.dart';
import 'package:luarsekolah/features/class/data/repositories/class_repository.dart';
import 'package:luarsekolah/features/class/domain/usecases/get_courses_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/create_course_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/update_course_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/delete_course_usecase.dart';
import 'package:luarsekolah/features/class/presentation/controllers/class_controller.dart';
import 'package:luarsekolah/core/services/dio_client.dart';

class ClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseService(DioClient()));
    Get.lazyPut(() => ClassRepository(Get.find()));
    Get.lazyPut(() => GetCoursesUseCase(Get.find()));
    Get.lazyPut(() => CreateCourseUseCase(Get.find()));
    Get.lazyPut(() => UpdateCourseUseCase(Get.find()));
    Get.lazyPut(() => DeleteCourseUseCase(Get.find()));
    Get.lazyPut(() => ClassController(), fenix: true);
  }
}
