import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo[700]),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.indigo[800],
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
