import 'dart:typed_data';
import 'package:clothingapp/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary/cloudinary.dart';
import 'package:uuid/uuid.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Uint8List? _imageBytes;
  String? _existingImageUrl;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot snap =
    await _firestore.collection('users').doc(user.uid).get();

    if (snap.exists) {
      setState(() {
        _nameController.text = snap['name'] ?? "";
        _emailController.text = snap['email'] ?? "";
        _existingImageUrl = snap['imageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

      if (picked != null) {
        _imageBytes = await picked.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // 🔥 SIGNED CLOUDINARY UPLOAD (Only this method replaced)
  Future<String?> _uploadImageToCloudinary(Uint8List imageBytes) async {
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: dotenv.env['API_KEY'] ?? "",
        apiSecret: dotenv.env['API_SECRET'] ?? "",
        cloudName: dotenv.env['CLOUD_NAME'] ?? "",
      );
      List<String> downloadUrls = [];
      final uuid = const Uuid();
        final fileId = uuid.v4();

        final response = await cloudinary.upload(
          fileBytes: imageBytes,
          resourceType: CloudinaryResourceType.image,
          folder: "profile_image",
          fileName: "$fileId.jpg",
          progressCallback: (count, total) {
            print("Uploading $fileId ${(count / total * 100).toStringAsFixed(0)}%");
          },
        );
        String? secureUrl;
        if (response.isSuccessful) {
          secureUrl=response.secureUrl;
          print("Uploaded: ${response.secureUrl}");
        } else {
          print("Upload failed: ${response.error}");
        }
        return secureUrl;
    } catch (e) {
      debugPrint("Cloudinary Signed Upload Error: $e");
    }
    return null;
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    String? imageUrl = _existingImageUrl;

    if (_imageBytes != null) {
      imageUrl = await _uploadImageToCloudinary(_imageBytes!);
    }

    await _firestore.collection('users').doc(user.uid).set({
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      if (imageUrl != null) "imageUrl": imageUrl,
    }, SetOptions(merge: true));

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!)
                      : _existingImageUrl != null
                      ? NetworkImage(_existingImageUrl!)
                      : null,
                  child: (_imageBytes == null && _existingImageUrl == null)
                      ? const Icon(Icons.add_a_photo, size: 32)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
