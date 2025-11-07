import 'package:flutter/material.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';

class TodoLoadingState extends StatelessWidget {
  const TodoLoadingState({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.greenDecorative,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat todo...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
