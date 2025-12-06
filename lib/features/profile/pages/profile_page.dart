import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:get/get.dart';
import '../../auth/services/firebase_auth_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_dashboard.dart';
import '../widgets/profile_logout_section.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            const ProfileHeader(),

            // Dashboard Section
            const ProfileDashboard(),

            const SizedBox(height: 24),

            // Logout Section
            ProfileLogoutSection(
              onTap: () async {
                try {
                  await _authService.logout();

                  Get.offAllNamed(AppRoutes.login);

                  Get.snackbar(
                    'Logout Berhasil',
                    'Anda telah berhasil keluar',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                } catch (e) {
                  Get.snackbar(
                    'Logout Gagal',
                    'Terjadi kesalahan: $e',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
