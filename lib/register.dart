import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login2.dart';
import 'EditForm.dart'; // Edit page for later

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordV = true;
  final validate = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  String? _selectedCity; // This variable stores the ONE selected city

  // List of major cities in Gujarat for the dropdown
  final List<String> _gujaratCities = [
    'Ahmedabad',
    'Surat',
    'Vadodara',
    'Rajkot',
    'Bhavnagar',
    'Jamnagar',
    'Gandhinagar',
    'Junagadh',
    'Anand',
    'Morbi',
    'Mehsana',
    'Bharuch',
    'Porbandar',
    'Nadiad',
    'Gandhidham',
    'Veraval',
    'Surendranagar',
    'Amreli',
    'Palanpur',
    'Bhuj',
    'Godhra',
    'Valsad',
    'Vapi',
    'Navsari',
    'Patan',
    'Dahod',
    'Botad',
    'Jetpur',
    'Wadhwan',
    'Dhoraji',
    'Kalol',
    'Gondal',
    'Deesa',
    'Amreli',
  ];


  final CollectionReference users =
  FirebaseFirestore.instance.collection('users');

  Future<void> registerUser() async {
    try {
      final docRef = await users.add({
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'number': number.text,
        'city': _selectedCity, // The selected city is saved here
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!")),
      );

      // OPTIONAL: After registering, navigate directly to edit page (can remove if not needed)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserFormPage(docId: docRef.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration screen"),
          centerTitle: true,
        ),
        body:
        Stack(
          children: [
            Image.asset(
              "assets/back.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            Center(
              child: Card(
                shadowColor: Colors.purple,
                elevation: 50,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: validate,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: name,
                            validator: (msg) {
                              if (msg == null || msg.isEmpty) {
                                return "Please enter a valid user name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "User Name",
                              hintText: "Enter your Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(Icons.verified_user),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Enter your Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(Icons.account_box),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              }
                              final emailPattern =
                              RegExp(r'^[\w.-]+@[\w]+\.+[\w]{2,4}$');
                              if (!emailPattern.hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: password,
                            obscureText: passwordV,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordV = !passwordV;
                                  });
                                },
                                icon: Icon(passwordV
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: number,
                            keyboardType: TextInputType.phone,
                            validator: (msg) {
                              if (msg == null || msg.isEmpty) {
                                return "Please enter your phone number";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              hintText: "Enter your phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(Icons.phone),
                            ),
                          ),
                        ),
                        // This is the added City Dropdown
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCity, // Bound to a single selected value
                            hint: const Text("Select your City"),
                            decoration: InputDecoration(
                              labelText: "City",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(Icons.location_city),
                            ),
                            items: _gujaratCities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCity = newValue; // Updates to only ONE new value
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select your city";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Validate the form before attempting registration
                            if (validate.currentState?.validate() ?? false) {
                              registerUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Login2()),
                            );
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],)
    );
  }
}