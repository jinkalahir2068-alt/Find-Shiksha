import 'package:register_app/AdminPage.dart' show Adminpage, TuitionInfoPage, tuitionInfo;
import 'lib/AdminPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adminloginscreen extends StatefulWidget {
  const Adminloginscreen({super.key});

  @override
  State<Adminloginscreen> createState() => _AdminloginscreenState();
}

class _AdminloginscreenState extends State<Adminloginscreen> {
  final TextEditingController _adminEmailContoller = TextEditingController();
  final TextEditingController _adminPasswordContoller = TextEditingController();
  bool passwordV = true;
  final validate = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<bool> validateAdminCredentials(String email, String password) async {
    try {
      final QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection("admins")
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminSnapshot.docs.isEmpty) return false;

      final adminData = adminSnapshot.docs.first.data() as Map<String, dynamic>;
      return adminData["password"] == password;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching admin credentials: $e")),
      );
      return false;
    }
  }

  Future<void> loginAsAdmin() async {
    final email = _adminEmailContoller.text.trim();
    final password = _adminPasswordContoller.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details")),
      );
      return;
    }

    try {
      final isAdminValid = await validateAdminCredentials(email, password);
      if (isAdminValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Adminpage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid details")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Login")),
      body: Stack(
        children: [
          Image.asset(
            "assets/img/img3.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Form(
                  key: validate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login Screen",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _adminEmailContoller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Username/Email",
                          labelText: "Username/Email",
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _adminPasswordContoller,
                        obscureText: passwordV,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordV ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordV = !passwordV;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Password",
                          labelText: "Password",
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: loginAsAdmin,
                        child: Text("Login as Admin"),
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
    )
    );
}
}
