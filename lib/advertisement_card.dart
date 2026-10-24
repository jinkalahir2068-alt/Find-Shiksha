import 'package:flutter/material.dart';

class AdvertisementCard extends StatelessWidget {
  final String text;

  const AdvertisementCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
      ),
    );
  }
}
