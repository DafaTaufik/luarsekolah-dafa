import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../auth/services/firebase_auth_service.dart';
import '../widgets/profile_text_field.dart';
import '../widgets/profile_readonly_field.dart';
import '../widgets/profile_date_picker_field.dart';
import '../widgets/profile_dropdown_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  DateTime? _selectedDate;
  String? _jenisKelamin;
  String? _statusPekerjaan;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final user = _authService.currentUser;
      if (user == null) {
        Get.back();
        return;
      }

      // Load user data from Firestore
      final userData = await _authService.getUserData(user.uid);

      if (userData != null) {
        // Set email and phone (read-only)
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';

        // Set editable fields
        _namaController.text = userData['name'] ?? '';

        if (userData['birthDate'] != null) {
          final timestamp = userData['birthDate'] as Timestamp;
          _selectedDate = timestamp.toDate();
        }

        _alamatController.text = userData['address'] ?? '';
        _jenisKelamin = userData['gender'];
        _statusPekerjaan = userData['jobStatus'];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      await _authService.updateUserData(
        uid: user.uid,
        name: _namaController.text.trim(),
        birthDate: _selectedDate,
        address: _alamatController.text.trim().isEmpty
            ? null
            : _alamatController.text.trim(),
        gender: _jenisKelamin,
        jobStatus: _statusPekerjaan,
      );

      Get.back();

      Get.snackbar(
        'Berhasil',
        'Profile berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Kontak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email (Read-only)
                    ProfileReadOnlyField(
                      label: 'Email',
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),

                    // Phone (Read-only)
                    ProfileReadOnlyField(
                      label: 'Nomor Telepon',
                      hintText: 'Nomor Telepon',
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 20),

                    // Nama Lengkap
                    ProfileTextField(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama lengkap',
                      controller: _namaController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama lengkap tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tanggal Lahir
                    ProfileDatePickerField(
                      label: 'Tanggal Lahir',
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Jenis Kelamin
                    ProfileDropdownField(
                      label: 'Jenis Kelamin',
                      hintText: 'Pilih jenis kelamin',
                      value: _jenisKelamin,
                      items: const ['Laki-Laki', 'Perempuan'],
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Status Pekerjaan
                    ProfileDropdownField(
                      label: 'Status Pekerjaan',
                      hintText: 'Pilih status pekerjaan',
                      value: _statusPekerjaan,
                      items: const [
                        'Presiden',
                        'Karyawan',
                        'Wiraswasta',
                        'Pelajar',
                        'Mahasiswa',
                        'Lainnya',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _statusPekerjaan = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Alamat Lengkap
                    ProfileTextField(
                      label: 'Alamat Lengkap',
                      hintText: 'Masukkan alamat lengkap',
                      controller: _alamatController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    CustomButton(
                      text: _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                      onPressed: _isSaving ? null : _saveProfile,
                      backgroundColor: const Color(0xFF077E60),
                      textColor: Colors.white,
                      height: 48,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
