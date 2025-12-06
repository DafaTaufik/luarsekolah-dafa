import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/class/presentation/widgets/course_card.dart';
import 'package:luarsekolah/features/class/presentation/widgets/error_view.dart';
import 'package:luarsekolah/features/routes/app_routes.dart';
import 'package:luarsekolah/shared/widgets/custom_button.dart';
import 'package:luarsekolah/features/class/presentation/controllers/class_controller.dart';
import 'package:luarsekolah/features/class/presentation/pages/add_class_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<dynamic> _getFilteredCourses(ClassController controller) {
    final currentTabIndex = _tabController.index;

    if (currentTabIndex == 0) {
      // Kelas Terpopuler - tampilkan semua kelas
      return controller.courses;
    } else if (currentTabIndex == 1) {
      // Kelas SPL - filter kelas dengan tag 'spl'
      return controller.courses.where((course) {
        return course.categoryTag.any((tag) => tag.toLowerCase() == 'spl');
      }).toList();
    } else {
      // Kelas Lainnya - filter kelas yang bukan SPL
      return controller.courses.where((course) {
        return !course.categoryTag.any((tag) => tag.toLowerCase() == 'spl');
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black54,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                onTap: (_) {
                  setState(() {}); // Rebuild untuk update filter
                },
                tabs: const [
                  Tab(text: 'Kelas Terpopuler'),
                  Tab(text: 'Kelas SPL'),
                  Tab(text: 'Kelas Lainnya'),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        onPressed: () async {
                          // Use pushScreen with persistent bottom nav bar
                          final result = await pushScreen(
                            context,
                            screen: const AddClassPage(),
                            withNavBar: false, // Hide nav bar on add class page
                          );

                          // If success, trigger rebuild to show new item
                          if (result == true && mounted) {
                            setState(() {});
                          }
                        },
                      ),
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

                        final filteredCourses = _getFilteredCourses(controller);

                        if (filteredCourses.isEmpty) {
                          return Center(
                            child: Text(
                              'Tidak ada kelas tersedia',
                              style: TextStyle(
                                color: AppColors.textNeutralLow,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: filteredCourses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
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
                              types: types.isNotEmpty
                                  ? types
                                  : [CourseType.prakerja],
                              price: price,
                              onTap: () {
                                print('Course ${course.id} tapped');
                              },
                              onEdit: () {
                                Get.toNamed(
                                  AppRoutes.editClass,
                                  arguments: course,
                                );
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
          ],
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
