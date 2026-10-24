import 'package:flutter/material.dart';

class BoxGridItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const BoxGridItem({super.key, required this.title, required this.icon});

  // Icon color (strong color)
  Color _getIconColor(String title) {
    switch (title.toLowerCase()) {
      case 'science':
        return const Color(0xFF4A90E2); // Fresh Blue
      case 'commerce':
        return const Color(0xFFFF7043); // Soft Orange
      case 'arts':
        return const Color(0xFF8E24AA); // Elegant Purple
      case 'drawing':
        return const Color(0xFF009688); // Calm Teal
      case 'english spoken':
      case 'eng spoken':
        return const Color(0xFF5C6BC0); // Soft Indigo
      case 'competitive exam':
        return const Color(0xFF43A047); // Rich Green
      case '1 to 10':
        return const Color(0xFFEF5350); // Bright Coral Red
      default:
        return const Color(0xFF9E9E9E); // Neutral Gray
    }
  }

  // Background color (light/pastel version of icon color)
  Color _getBackgroundColor(String title) {
    switch (title.toLowerCase()) {
      case 'science':
        return const Color(0xFFE3F2FD); // Light Blue
      case 'commerce':
        return const Color(0xFFFFEBEE); // Light Orange/Red
      case 'arts':
        return const Color(0xFFF3E5F5); // Light Purple
      case 'drawing':
        return const Color(0xFFE0F2F1); // Light Teal
      case 'english spoken':
      case 'eng spoken':
        return const Color(0xFFE8EAF6); // Light Indigo
      case 'competitive exam':
        return const Color(0xFFE8F5E9); // Light Green
      case '1 to 10':
        return const Color(0xFFFFEBEE); // Light Red
      default:
        return const Color(0xFFF5F5F5); // Light Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = _getIconColor(title);
    final Color bgColor = _getBackgroundColor(title);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 50,
            weight: 1300,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
