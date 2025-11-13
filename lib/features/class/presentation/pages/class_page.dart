import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/class/presentation/widgets/course_card.dart';
import 'package:luarsekolah/features/class/presentation/widgets/error_view.dart';
import 'package:luarsekolah/features/routes/app_routes.dart';
import 'package:luarsekolah/shared/widgets/custom_button.dart';
import 'package:luarsekolah/features/class/presentation/controllers/class_controller.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();
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
                  const Text(
                    'Kelas Terpopuler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        Get.toNamed(AppRoutes.addClass);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (controller.hasError) {
                    return ErrorView(
                      message: controller.errorMessage,
                      onRetry: () => controller.refreshCourses(),
                    );
                  }
                  if (controller.courses.isEmpty) {
                    return ListView(children: const []);
                  }
                  return ListView.separated(
                    itemCount: controller.courses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final course = controller.courses[index];
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
                          Get.toNamed(AppRoutes.editClass, arguments: course);
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
              onPressed: () => Get.back(),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textNeutralHigh),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
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
