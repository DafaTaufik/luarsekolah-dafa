import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/shared/widgets/custom_button.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';
import 'package:luarsekolah/features/class/models/course.dart';
import 'package:luarsekolah/features/class/controllers/class_controller.dart';

class EditClassPage extends StatefulWidget {
  final Course course;

  const EditClassPage({super.key, required this.course});

  @override
  State<EditClassPage> createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _thumbnailController;
  late TextEditingController _ratingController;

  List<String> _selectedCategories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.course.name);
    _priceController = TextEditingController(text: widget.course.price);
    _thumbnailController = TextEditingController(
      text: widget.course.thumbnail ?? '',
    );
    _ratingController = TextEditingController(text: widget.course.rating ?? '');

    // Initialize selected categories
    _selectedCategories = List.from(widget.course.categoryTag);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _thumbnailController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
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

    // Create update request
    final updateRequest = UpdateCourseRequest(
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

    // Get controller and update
    final controller = Get.find<ClassController>();
    final success = await controller.updateCourse(
      widget.course.id,
      updateRequest,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigate back to class page
      Navigator.of(context, rootNavigator: true).pop();
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
                  'Edit Kelas',
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

                // Simpan Button
                CustomButton(
                  text: _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                  backgroundColor: AppColors.btnPrimary,
                  textColor: Colors.white,
                  height: 46,
                  borderRadius: 8,
                  onPressed: _isLoading ? null : _handleUpdate,
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
                          Navigator.of(context, rootNavigator: true).pop();
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
