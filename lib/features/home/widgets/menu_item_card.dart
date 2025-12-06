import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable menu item widget for horizontal menu in Home Page
/// Used in HomePage for navigation menu items
class MenuItemCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;
  final Color? iconBackgroundColor;

  const MenuItemCard({
    Key? key,
    required this.iconPath,
    required this.label,
    this.onTap,
    this.iconBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image not found
                  return Icon(Icons.apps, size: 32, color: Colors.grey[600]);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Label
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
