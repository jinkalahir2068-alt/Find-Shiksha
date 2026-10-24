import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomCard() {
  return Card(
    elevation: 5,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ProfileCardContent(
      name: 'David Lee',
      role: 'Backend Developer',
      imageUrl: 'https://i.pravatar.cc/150?img=12',
    ),
  );
}

Widget ProfileCardContent({
  required String name,
  required String role,
  required String imageUrl,
}) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 30,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(role,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ],
    ),
  );
}