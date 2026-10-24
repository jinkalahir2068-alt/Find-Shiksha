import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PastelHomeScreen(),
    );
  }
}

class PastelHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB), // very soft cream

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFDFCFB),
        title: const Text(
          "MCQ App",
          style: TextStyle(
            color: Color(0xFF5D576B),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Choose Category",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF6A6A80),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  pastelCard("Maths", const Color(0xFFFFE5EC)),
                  pastelCard("Science", const Color(0xFFFFF1D0)),
                  pastelCard("GK", const Color(0xFFE7F8FF)),
                  pastelCard("English", const Color(0xFFE8F5E9)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pastelCard(String title, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor, // pastel background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(3, 4),
          )
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF5D576B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
       ),
    );
  }
}
