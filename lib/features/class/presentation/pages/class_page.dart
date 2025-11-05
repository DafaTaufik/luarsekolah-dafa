import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/class/presentation/widgets/course_card.dart';
import 'package:luarsekolah/features/class/presentation/widgets/error_view.dart';
import 'package:luarsekolah/core/constants/app_routes.dart';
import 'package:luarsekolah/shared/widgets/custom_button.dart';
import 'package:luarsekolah/features/class/controllers/class_controller.dart';
import 'package:luarsekolah/features/class/services/course_service.dart';
import 'package:luarsekolah/core/services/dio_client.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create controller instance directly with Get.put
    final controller = Get.put(ClassController(CourseService(DioClient())));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Kelas Terpopuler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // btn Tambah Kelas
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'Tambah Kelas',
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: 45,
                      borderRadius: 8,
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.addClass);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // List Course Cards Obx
              Expanded(
                child: Obx(() {
                  // Show loading indicator
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // Show error view
                  if (controller.hasError) {
                    return ErrorView(
                      message: controller.errorMessage,
                      onRetry: () => controller.refreshCourses(),
                    );
                  }

                  // Show empty list or courses
                  if (controller.courses.isEmpty) {
                    return ListView(children: const []);
                  }

                  // Show list of courses
                  return ListView.separated(
                    itemCount: controller.courses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final course = controller.courses[index];

                      // Map categoryTag strings to CourseType enum
                      final types = course.categoryTag
                          .map((tag) {
                            if (tag.toLowerCase() == 'prakerja') {
                              return CourseType.prakerja;
                            } else if (tag.toLowerCase() == 'spl') {
                              return CourseType.spl;
                            }
                            return null;
                          })
                          .whereType<CourseType>()
                          .toList();

                      // Parse price from string to double
                      final price = double.tryParse(course.price) ?? 0;

                      return CourseCard(
                        imageUrl: course.thumbnail ?? '',
                        title: course.name,
                        types: types.isNotEmpty ? types : [CourseType.prakerja],
                        price: price,
                        onTap: () {
                          print('Course ${course.id} tapped');
                        },
                        onEdit: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(AppRoutes.editClass, arguments: course);
                        },
                        onDelete: () {
                          _showDeleteConfirmation(
                            context,
                            course.id,
                            course.name,
                            controller,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext context,
    String courseId,
    String courseName,
    ClassController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kelas'),
          content: Text(
            'Apakah Anda yakin ingin menghapus kelas "$courseName"?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textNeutralHigh),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteCourse(courseId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
