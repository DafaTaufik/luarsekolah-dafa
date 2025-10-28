import 'package:flutter/material.dart';
import 'package:luarsekolah/features/todo/models/todo.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onToggle;
  final Function(Todo) onEdit;
  final Function(Todo) onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.completed
                        ? AppColors.greenDecorative
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: todo.completed
                      ? AppColors.greenDecorative
                      : Colors.transparent,
                ),
                child: todo.completed
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: todo.completed ? Colors.grey[600] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(todo.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(todo);
                } else if (value == 'delete') {
                  onDelete(todo);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference < 7) {
      return ' $difference hari yang lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
