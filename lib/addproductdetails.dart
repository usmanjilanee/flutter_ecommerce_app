// create_product_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String _selectedCategory = 'Uncategorized';

  //final List<File> _selectedImages = [];
  List<Uint8List> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Variants: each variant has name and price
  List<Map<String, TextEditingController>> _variants = [];

  bool _isSubmitting = false;

  // Example categories - change as needed
  final List<String> _categories = [
    'Uncategorized',
    'Electronics',
    'Clothing',
    'Home',
    'Beauty',
    'Books',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Start with one variant row by default
    _addVariant();
  }

  @override
  void dispose() {
    _titleController.dispose();
    descriptionController.dispose();
    for (var v in _variants) {
      v['name']?.dispose();
      v['price']?.dispose();
    }
    super.dispose();
  }

  void _addVariant() {
    setState(() {
      _variants.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void _removeVariant(int index) {
    setState(() {
      _variants[index]['name']?.dispose();
      _variants[index]['price']?.dispose();
      _variants.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    // try {
    //   final XFile? picked = await _picker.pickImage(
    //     source: ImageSource.gallery,
    //     imageQuality: 85,
    //   );
    //   if (picked != null) {
    //     setState(() {
    //       _selectedImages.add(File(picked.path));
    //     });
    //   }
    // } catch (e) {
    //   // handle errors
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Image pick failed: $e')),
    //   );
    // }
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked != null) {
        final bytes = await picked.readAsBytes(); // Get bytes

        setState(() {
          _selectedImages.add(bytes); // Store Uint8List directly
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image pick failed: $e')),
      );
    }

  }

  Future<List<String>> _uploadImagesToFirebase() async {
    // final storage = FirebaseStorage.instance;
    final cloudinary = Cloudinary.signedConfig(
      apiKey: dotenv.env['API_KEY'] ?? "",
      apiSecret: dotenv.env['API_SECRET'] ?? "",
      cloudName: dotenv.env['CLOUD_NAME'] ?? "",
    );
    List<String> downloadUrls = [];
    final uuid = const Uuid();
    for (final bytes in _selectedImages) {
      final fileId = uuid.v4();

      final response = await cloudinary.upload(
        fileBytes: bytes,
        resourceType: CloudinaryResourceType.image,
        folder: "product_images",
        fileName: "$fileId.jpg",
        progressCallback: (count, total) {
          print("Uploading $fileId ${(count / total * 100).toStringAsFixed(0)}%");
        },
      );

      if (response.isSuccessful) {
        downloadUrls.add(response.secureUrl!);
        print("Uploaded: ${response.secureUrl}");
      } else {
        print("Upload failed: ${response.error}");
      }
    }
    // for (final file in _selectedImages) {
    //   final fileId = uuid.v4(); // unique filename
    //
    //   final response = await cloudinary.upload(
    //     file: file.path,
    //     fileBytes: file.readAsBytesSync(),
    //     resourceType: CloudinaryResourceType.image,
    //     folder: "product_images",
    //     fileName: "$fileId.jpg",
    //     progressCallback: (count, total) {
    //       print("Uploading $fileId ${(count / total * 100).toStringAsFixed(0)}%");
    //     },
    //   );
    //
    //   if (response.isSuccessful) {
    //     print("Uploaded: ${response.secureUrl}");
    //     downloadUrls.add(response.secureUrl!);
    //   } else {
    //     print("Upload failed: ${response.error}");
    //   }
    // }

    // for (final file in _selectedImages) {
    //   final String fileId = uuid.v4();
    //   final ref = storage.ref().child('product_images/$fileId.jpg');
    //   final uploadTask = await ref.putFile(file);
    //   final url = await uploadTask.ref.getDownloadURL();
    //   downloadUrls.add(url);
    // }
    // for (var image in _selectedImages) {
    //   final fileName = Uuid().v4();
    //   final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');
    //
    //   Uint8List bytes = await image.readAsBytes(); // Works on Mobile & Web
    //
    //   // Upload as bytes
    //   await storageRef.putData(bytes);
    //
    //   // Get download URL
    //   final url = await storageRef.getDownloadURL();
    //   downloadUrls.add(url);
    // }

    return downloadUrls;
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }
    // Validate at least one variant price
    bool hasPrice = false;
    for (var v in _variants) {
      if ((v['price']?.text ?? '').trim().isNotEmpty) {
        hasPrice = true;
        break;
      }
    }
    if (!hasPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one variant price')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1) Upload images
      final imageUrls = await _uploadImagesToFirebase();

      // 2) Prepare variants list
      final List<Map<String, dynamic>> variantsList = _variants
          .where((v) =>
      (v['name']?.text.trim().isNotEmpty ?? false) ||
          (v['price']?.text.trim().isNotEmpty ?? false))
          .map((v) => {
        'name': v['name']?.text.trim() ?? '',
        'price': double.tryParse(v['price']?.text.trim() ?? '') ?? 0.0,
      })
          .toList();
      // Get currently logged in user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }
      // Fetch user details from Firestore
      final userDocSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDocSnap.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User profile not found")),
        );
        return;
      }

      final userData = userDocSnap.data()!;
      // 3) Create product doc
      final doc = {
        'title': _titleController.text.trim(),
        'description':descriptionController.text.trim(),
        'category': _selectedCategory,
        'images': imageUrls,
        'variants': variantsList,
        'createdAt': FieldValue.serverTimestamp(),
        'sellerId': user.uid,
        'sellerName': userData['name'] ?? '',
        'sellerEmail': userData['email'] ?? user.email,
        'sellerPhone': userData['phone'] ?? '',
        'sellerProfileImage': userData['profileImage'] ?? '', // In this way when you use this data you will not get the updated seller image so using only seller id and fetching/populating seller each time would be good approach
      };

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('products').add(doc);

      // success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully!')),
      );

      // reset form
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit product: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _titleController.clear();
    descriptionController.clear();
    _selectedCategory = _categories.first;
    for (var v in _variants) {
      v['name']?.clear();
      v['price']?.clear();
    }
    _variants = [];
    _addVariant();
    _selectedImages.clear();
    setState(() {});
  }

  // long press on thumbnail to confirm delete
  void _confirmDeleteImage(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove image?'),
        content: const Text('Do you want to remove this selected image?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedImages.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesRow() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          if (idx == 0) {
            // plus button
            return GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.add, size: 36)),
              ),
            );
          } else {
            final image = _selectedImages[idx - 1];
            return GestureDetector(
              onLongPress: () => _confirmDeleteImage(idx - 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // child: Image.memory(
                //   image.readAsBytesSync(),
                // child: Image.file(
                //   image,
                child: Image.memory(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildVariantsSection() {
    return Column(
      children: [
        Row(
          children: [
            const Text('Variants', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
              onPressed: _addVariant,
              icon: const Icon(Icons.add),
              label: const Text('Add Variant'),
            )
          ],
        ),
        ListView.builder(
          itemCount: _variants.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            final nameCtrl = _variants[i]['name']!;
            final priceCtrl = _variants[i]['price']!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Variant name (e.g., Size L, Red)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixText: 'Rs ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) return null; // optional
                        if (double.tryParse(v!.trim()) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_variants.length > 1)
                    IconButton(
                      onPressed: () => _removeVariant(i),
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: _isSubmitting,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildImagesRow(),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Enter product title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Enter product title' : null,
                ),
                const SizedBox(height: 16),

                // Category dropdown
                Row(
                  children: [
                    const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v ?? _categories.first),
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildVariantsSection(),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitProduct,
                    child: _isSubmitting
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text('Submit Product', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
