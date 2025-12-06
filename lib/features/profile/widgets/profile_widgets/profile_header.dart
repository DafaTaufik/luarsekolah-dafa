import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/services/firebase_auth_service.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Column(
            children: [
              // Title "Profile"
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Profile Card
              StreamBuilder(
                stream: authService.authStateChanges,
                builder: (context, authSnapshot) {
                  // If no user logged in
                  if (!authSnapshot.hasData || authSnapshot.data == null) {
                    return _buildProfileCard(context, 'Guest', false);
                  }

                  final user = authSnapshot.data!;

                  // Stream user data from Firestore
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: authService.getUserDataStream(user.uid),
                    builder: (context, userSnapshot) {
                      String userName = 'User';
                      bool isLoading =
                          userSnapshot.connectionState ==
                          ConnectionState.waiting;

                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        final userData = userSnapshot.data!.data();
                        userName = userData?['name'] ?? 'User';
                      }

                      return _buildProfileCard(context, userName, isLoading);
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String userName,
    bool isLoading,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.editProfile);
        },
        borderRadius: BorderRadius.circular(12),
        child: Transform.translate(
          offset: const Offset(-8, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name and Greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Semangat Belajarnya,',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Loading state or user name
                      isLoading
                          ? SizedBox(
                              width: 100,
                              height: 20,
                              child: Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              userName,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ],
                  ),
                ),

                // Chevron Icon
                const Icon(Icons.chevron_right, color: Colors.white, size: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
