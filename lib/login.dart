import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ex.dart' show Register;

class login extends StatefulWidget {
  const login({super.key});
  @override
  State<login> createState() => _LoginState();
}

class _LoginState extends State<login> {
  bool passwordV = true;
  final validate = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> loginUser() async {
    if (validate.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        // No Navigator — StreamBuilder in main.dart will redirect to Adminpage
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
                      const Text(
                        "Login Screen",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: email,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Enter email" : null,
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: password,
                        obscureText: passwordV,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Enter password" : null,
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
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: loginUser,
                        child: const Text("Login"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Register()),
                          );
                        },
                        child: const Text("Register here"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
