import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class StudentForm extends StatefulWidget {
  final String? userDocId;
  const StudentForm({
    super.key,
    this.userDocId,
    required Map<String, dynamic> tuitionData,
    required String docId,
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  File? _imageFile;
  String? _imageUrl;
  String? selectedCity;

  final List<String> gujaratCities = [
    'Ahmedabad',
    'Surat',
    'Vadodara',
    'Rajkot',
    'Bhavnagar',
    'Jamnagar',
    'Gandhinagar',
    'Junagadh',
    'Anand',
    'Nadiad',
    'Porbandar',
    'Valsad',
    // Add more cities if needed
  ];

  @override
  void initState() {
    super.initState();
    if (widget.userDocId != null) {
      _loadUserData(widget.userDocId!);
    }
  }

  Future<void> _loadUserData(String docId) async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(docId).get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          nameController.text = data['name'] ?? '';
          contactController.text = data['number'] ?? '';
          emailController.text = data['email'] ?? '';
          selectedCity = data['city'] ?? '';
          addressController.text = selectedCity ?? '';
          _imageUrl = data['profileImage']; // Optional
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToCloudinary(File imageFile) async {
    const cloudinaryUrl = "https://api.cloudinary.com/v1_1/your_cloud_name/image/upload";
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'upload_preset': "your_upload_preset",
    });

    final response = await Dio().post(cloudinaryUrl, data: formData);
    return response.data['secure_url'];
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      String? uploadedImageUrl = _imageUrl;

      if (_imageFile != null) {
        uploadedImageUrl = await uploadImageToCloudinary(_imageFile!);
      }

      await FirebaseFirestore.instance.collection('tuitions').add({
        'name': nameController.text,
        'contact': contactController.text,
        'email': emailController.text,
        'address': selectedCity,
        'imageUrl': uploadedImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tuition added successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Tuition')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_imageUrl != null
                      ? NetworkImage(_imageUrl!) as ImageProvider
                      : const AssetImage('assets/placeholder.png')),
                  child: _imageFile == null && _imageUrl == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Enter contact' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'City'),
                value: selectedCity != '' ? selectedCity : null,
                items: gujaratCities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    addressController.text = value ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Select a city' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
