import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final String batchInfo;
  final String projectTitle;
  final String organizer;
  final String quota;
  final VoidCallback? onTap;

  const ProjectCard({
    Key? key,
    required this.batchInfo,
    required this.projectTitle,
    required this.organizer,
    required this.quota,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              width: 62,
              height: 62,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[600]),
                );
              },
            ),
            SizedBox(height: 16),

            // Batch Info
            Text(
              batchInfo,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blueInteractive,
              ),
            ),
            SizedBox(height: 8),

            // Project Title
            Text(
              projectTitle,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Organizer
            Text(
              organizer,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 16),

            // Button
            InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFCBCECF), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Lihat Detail Proyek',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Quota Info
            Text(
              quota,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
