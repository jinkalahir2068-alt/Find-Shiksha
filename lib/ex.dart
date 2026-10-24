// import 'package:application/Project/ProfilePage.dart';
// import 'package:application/Project/homePage.dart';
// import 'package:application/Project/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ProfilePage.dart' show ProfilePage;
import 'homePage.dart' show HomePage;
import 'homepage.dart';
import 'login.dart' show login;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordV= true;
  final validate = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final number = TextEditingController();

  Future<void> register() async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name.text,
        'email': email.text,
        'number': number.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful")),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => homePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Registration screen"),centerTitle: true
        ,),
      body: Center(
        child: Card(
          shadowColor: Colors.purple,
          elevation: 50,
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          child: Form(
            key: validate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/img/p1.jpg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: TextFormField(
                      controller: name,
                      validator: (dynamic msg)
                      {
                        if(msg.isEmpty || msg==null)
                        {
                          return "please enter valid user name";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "User Name",
                        hintText: "Enter your Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon:  Icon(Icons.verified_user),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.account_box),
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty)
                          {
                            return "please enter email";
                          }
                          final emailPattern=RegExp(r'^[\w.-]+@[\w]+\.+[\w]{2,4}$');
                          if(!emailPattern.hasMatch(value))
                          {
                            return "please enter valid email";
                          }
                          return null;
                        },
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: TextFormField(
                      obscureText: passwordV,
                      decoration: InputDecoration(
                          labelText: "password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(Icons.password),
                          suffixIcon:IconButton(onPressed:()
                          {
                            setState(() {
                              passwordV=!passwordV;
                            });
                          },
                              icon: Icon(passwordV?Icons.visibility_off:Icons.visibility))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "confirm password",
                        hintText: "confirm password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.verified_user),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Number",
                        hintText: "Enter your number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.add_call),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(_)=>ProfilePage()));
                    if(validate.currentState?.validate()??false)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Reg. Done"),));
                    }
                  }, child: Text("Register")),
                  TextButton(onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder:(_)=>login()));

                  }
                      ,child: Text("login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}



