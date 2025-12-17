import 'package:clothingapp/selection_screen.dart';
import 'package:clothingapp/update_profile.dart';
import 'package:clothingapp/updateprofile_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreenAdmin extends StatelessWidget {
  const ProfileScreenAdmin({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user info found"));
          }

          var userData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData["imageUrl"] != null
                        ? NetworkImage(userData["imageUrl"])
                        : const NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    userData["name"] ?? "Unknown User",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    userData["email"] ?? "Not Available",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 4),

                  // Role Display
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userData["role"] == "Admin" ? "Admin" : "Customer",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.security_update_outlined),
                    title: const Text("Update Profile"),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreenAdmin()));
                    },
                  ),

                  // Address
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text("Address"),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),

                  Divider(thickness: 1),

                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text("Help"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text("Feedback"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text("Privacy Policy"),
                    onTap: () {},
                  ),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthSelectionScreen()));
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
