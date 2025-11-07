import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/shared/widgets/custom_button.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/class/data/models/course.dart';
import 'package:luarsekolah/features/class/presentation/controllers/class_controller.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _ratingController = TextEditingController();

  List<String> _selectedCategories = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama kelas tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_priceController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Harga kelas tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih minimal satu kategori',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Create request
    final createRequest = CreateCourseRequest(
      name: _nameController.text.trim(),
      price: _priceController.text.trim(),
      categoryTag: _selectedCategories,
      thumbnail: _thumbnailController.text.trim().isEmpty
          ? null
          : _thumbnailController.text.trim(),
      rating: _ratingController.text.trim().isEmpty
          ? null
          : _ratingController.text.trim(),
    );

    // Get controller and create
    final controller = Get.find<ClassController>();
    final success = await controller.createCourse(createRequest);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigate back to class page after successful creation
      if (mounted) {
        Get.back();
      }
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Kelas',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Kelas
                Text(
                  'Nama Kelas',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g Marketing Communication',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Harga Kelas
                Text(
                  'Harga Kelas',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g 1000000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Masukkan dalam bentuk angka (tanpa titik/koma)',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 18),

                // Kategori Kelas (Multiple Selection)
                Text(
                  'Kategori Kelas',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Prakerja'),
                        value: _selectedCategories.contains('prakerja'),
                        onChanged: (bool? value) {
                          _toggleCategory('prakerja');
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('SPL'),
                        value: _selectedCategories.contains('spl'),
                        onChanged: (bool? value) {
                          _toggleCategory('spl');
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Thumbnail URL
                Text(
                  'Thumbnail URL',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _thumbnailController,
                  decoration: InputDecoration(
                    hintText: 'https://example.com/image.jpg (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Rating
                Text(
                  'Rating',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g 4.5 (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tambah Button
                CustomButton(
                  text: _isLoading ? 'Menambahkan...' : 'Tambah Kelas',
                  backgroundColor: AppColors.btnPrimary,
                  textColor: Colors.white,
                  height: 46,
                  borderRadius: 8,
                  onPressed: _isLoading ? null : _handleCreate,
                ),
                const SizedBox(height: 16),

                // Kembali Button
                CustomButton(
                  text: 'Kembali',
                  backgroundColor: AppColors.secondary,
                  textColor: Colors.white,
                  height: 46,
                  borderRadius: 8,
                  onPressed: _isLoading
                      ? null
                      : () {
                          Get.back();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
