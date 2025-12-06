import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title "Dashboard"
          Text(
            'Dashboard',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Dashboard Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgInfo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Kelas
                _buildStatItem(
                  icon: Icons.school_outlined,
                  label: 'Total Kelas',
                  value: '5 kelas',
                ),
                const SizedBox(height: 16),

                // Kelas Aktif
                _buildStatItem(
                  icon: Icons.check_circle_outline,
                  label: 'Kelas Aktif',
                  value: '3 kelas',
                ),
                const SizedBox(height: 16),

                // Kelas Tidak Aktif
                _buildStatItem(
                  icon: Icons.cancel_outlined,
                  label: 'Kelas Tidak Aktif',
                  value: '2 kelas',
                ),
                const SizedBox(height: 24),

                // Button
                CustomButton(
                  text: 'Telusuri Kelas Tersedia',
                  backgroundColor: AppColors.btnPrimary,
                  textColor: Colors.white,
                  borderRadius: 8,
                  height: 50,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  onPressed: () {
                    // TODO: Navigate to class browse page
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
