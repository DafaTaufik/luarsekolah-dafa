import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileLogoutSection extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileLogoutSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Logout Icon
                  Icon(Icons.logout, color: Colors.red.shade600, size: 24),
                  const SizedBox(width: 16),

                  // Logout Text
                  Expanded(
                    child: Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),

                  // Chevron Icon
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
