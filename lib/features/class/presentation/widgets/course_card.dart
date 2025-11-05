import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

enum CourseType { prakerja, spl }

class CourseCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final List<CourseType> types;
  final double price;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CourseCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.types,
    required this.price,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isMenuOpen = false;

  Color _getTypeColor(CourseType type) {
    switch (type) {
      case CourseType.prakerja:
        return AppColors.blueDecorative;
      case CourseType.spl:
        return AppColors.greenDecorative;
    }
  }

  String _getTypeLabel(CourseType type) {
    switch (type) {
      case CourseType.prakerja:
        return 'Prakerja';
      case CourseType.spl:
        return 'SPL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.imageUrl.isEmpty
                    ? Container(
                        // Empty/No thumbnail
                        width: 120,
                        height: 120,
                        color: const Color(0xFFA7AAB9).withOpacity(0.2),
                        child: const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.textNeutralLow,
                        ),
                      )
                    : Image.network(
                        // For URL from API
                        widget.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            color: const Color(0xFFA7AAB9).withOpacity(0.2),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 40,
                              color: AppColors.textNeutralLow,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Badges (Prakerja/SPL)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.types.map((type) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getTypeLabel(type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Price
                    Text(
                      'Rp ${widget.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textNeutralHigh,
                      ),
                    ),
                  ],
                ),
              ),

              // More Icon Button
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: _isMenuOpen
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    color: _isMenuOpen
                        ? AppColors.primary
                        : AppColors.textNeutralHigh,
                    size: 20,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(0, 40),
                onOpened: () {
                  setState(() {
                    _isMenuOpen = true;
                  });
                },
                onCanceled: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
                onSelected: (value) {
                  setState(() {
                    _isMenuOpen = false;
                  });
                  if (value == 'delete' && widget.onDelete != null) {
                    widget.onDelete!();
                  } else if (value == 'edit' && widget.onEdit != null) {
                    widget.onEdit!();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
