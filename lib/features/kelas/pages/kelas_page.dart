import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/course_card.dart';

class KelasPage extends StatelessWidget {
  const KelasPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 12),

                  // Button Tambah Kelas
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Tambah Kelas pressed');
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Tambah Kelas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // List Course Cards
              Expanded(
                child: ListView(
                  children: [
                    CourseCard(
                      imageUrl: 'assets/images/class_1.png',
                      title: 'Teknik Pemilahan dan Pengolahan Sampah',
                      types: const [CourseType.prakerja, CourseType.spl],
                      price: 1500000,
                      onTap: () {
                        print('Course tapped');
                      },
                      onEdit: () {
                        print('Edit tapped');
                      },
                      onDelete: () {
                        print('Delete tapped');
                      },
                    ),
                    const SizedBox(height: 12),

                    CourseCard(
                      imageUrl: 'assets/images/class_2.png',
                      title:
                          'Pembuatan Pestisida Ramah Lingkungan untuk Petani Terampil',
                      types: const [CourseType.prakerja],
                      price: 850000,
                      onTap: () {
                        print('Course tapped');
                      },
                      onEdit: () {
                        print('Edit tapped');
                      },
                      onDelete: () {
                        print('Delete tapped');
                      },
                    ),
                    const SizedBox(height: 12),

                    CourseCard(
                      imageUrl: 'https://picsum.photos/200/302',
                      title: 'Digital Marketing untuk UMKM',
                      types: const [CourseType.spl],
                      price: 1200000,
                      onTap: () {
                        print('Course tapped');
                      },
                      onEdit: () {
                        print('Edit tapped');
                      },
                      onDelete: () {
                        print('Delete tapped');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
