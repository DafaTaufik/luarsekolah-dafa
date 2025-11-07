import 'package:get/get.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';
import 'package:luarsekolah/features/class/services/course_exception.dart';
import 'package:luarsekolah/features/class/domain/usecases/get_courses_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/create_course_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/update_course_usecase.dart';
import 'package:luarsekolah/features/class/domain/usecases/delete_course_usecase.dart';

class ClassController extends GetxController {
  final GetCoursesUseCase _getCourses = Get.find();
  final CreateCourseUseCase _createCourse = Get.find();
  final UpdateCourseUseCase _updateCourse = Get.find();
  final DeleteCourseUseCase _deleteCourse = Get.find();

  // Observable states
  final _isLoading = false.obs;
  final _courses = <Course>[].obs;
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Course> get courses => _courses;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  /// Fetch all courses from API
  Future<void> fetchCourses() async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';
      final response = await _getCourses();
      _courses.value = response.courses;
    } on CourseNetworkException catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.message;
    } on CourseNotFoundException catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.message;
    } on CourseException catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.message;
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Terjadi kesalahan tidak terduga';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete a course by ID
  Future<void> deleteCourse(String id) async {
    try {
      await _deleteCourse(id);
      _courses.removeWhere((course) => course.id == id);
      Get.snackbar(
        'Berhasil',
        'Kelas berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on CourseException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus kelas',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh courses
  Future<void> refreshCourses() async {
    await fetchCourses();
  }

  /// Update a course by ID
  Future<bool> updateCourse(String id, UpdateCourseRequest request) async {
    try {
      final updatedCourse = await _updateCourse(id, request);
      final index = _courses.indexWhere((course) => course.id == id);
      if (index != -1) {
        _courses[index] = updatedCourse;
      }
      Get.snackbar(
        'Berhasil',
        'Kelas berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } on CourseException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui kelas',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Create a new course
  Future<bool> createCourse(CreateCourseRequest request) async {
    try {
      final newCourse = await _createCourse(request);
      _courses.insert(0, newCourse);
      Get.snackbar(
        'Berhasil',
        'Kelas berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } on CourseException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan kelas',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
