import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'AddPage.dart';    // Import your StudentForm page
import 'UserList.dart';  // Import your UserList page (assuming it's correct)

class Adminpage extends StatefulWidget {
  const Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  // Function to handle user logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // After logout, you might want to navigate to a login screen.
    // Example: Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
    //   (Route<dynamic> route) => false,
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );
  }

  // Function to delete a tuition entry and its associated image from Firebase
  void deleteTuition(String docId, String? imageUrl) async {
    try {
      // 1. Delete image from Firebase Storage if imageUrl exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          // Create a reference from the URL and delete the file
          await FirebaseStorage.instance.refFromURL(imageUrl).delete();
          print('Image deleted from Firebase Storage: $imageUrl');
        } on FirebaseException catch (e) {
          // Handle cases where the image might not exist in storage (e.g., already deleted, invalid URL)
          if (e.code == 'object-not-found') {
            print('Image not found in Storage: $imageUrl (might have been deleted already)');
          } else {
            print('Error deleting image from Storage: ${e.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete image from Storage: ${e.message}')),
            );
            // Decide if you want to proceed with Firestore deletion even if image delete fails
            // For now, we'll proceed to delete the Firestore document.
          }
        }
      }

      // 2. Delete the document from Cloud Firestore
      await FirebaseFirestore.instance.collection('tuitions').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tuition entry and associated image deleted.')),
      );
    } catch (e) {
      print('Error deleting tuition: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete tuition: $e')),
      );
    }
  }

  // Function to navigate to the edit page
  void editTuition(Map<String, dynamic> tuitionData, String docId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentForm(
          tuitionData: tuitionData, // Pass existing data for pre-filling form
          docId: docId,             // Pass document ID for updating
        ),
      ),
    );

    // Check if the result indicates an update (e.g., by returning true or a specific string)
    if (result == true) { // Assuming StudentForm returns true on successful update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tuition updated successfully!')),
      );
    }
  }

  // Widget to build the tuition image, handling network loading and errors
  Widget _buildTuitionImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect( // Clip the image to match the container's border radius
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Return a placeholder or empty space if no image URL is provided
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 100, // Smaller placeholder height
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),

        child: const Center(
          child: Icon(Icons.school, color: Colors.grey, size: 40),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "Admin Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("List All Users"),
              onTap: () {
                // Assuming 'userlist()' is a valid page/widget
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => userlist`()));
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tuitions')
            .orderBy('name', descending: false) // Order by name for display
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tuition entries found.'));
          }

          final tuitionDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tuitionDocs.length,
            itemBuilder: (context, index) {
              var doc = tuitionDocs[index];
              var data = doc.data() as Map<String, dynamic>;
              String? imageUrl = data['imageUrl'] as String?; // Get the image URL

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the image using the helper function
                      _buildTuitionImage(imageUrl),
                      Text(
                        data['name'] ?? 'N/A', // Provide a default if null
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Address: ${data['address'] ?? 'N/A'}"),
                      Text("Contact: ${data['contact'] ?? 'N/A'}"),
                      Text("Email: ${data['email'] ?? 'N/A'}"),
                      // Display boards if they exist
                      if (data['gsrb'] == true || data['ncert'] == true || data['cbse'] == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Boards: ${data['gsrb'] == true ? 'GSEB ' : ''}${data['ncert'] == true ? 'NCERT ' : ''}${data['cbse'] == true ? 'CBSE' : ''}"
                                .trim(), // Trim to remove trailing space if only one board
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => editTuition(data, doc.id),
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => deleteTuition(doc.id, imageUrl), // Pass imageUrl for deletion
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentForm(tuitionData: {},  docId: '',)), // Navigate to add new tuition
          );
          if (result == true) { // Assuming StudentForm returns true on successful add
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New Tuition added successfully!')),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Tuition"),
      ),
    );
  }
}