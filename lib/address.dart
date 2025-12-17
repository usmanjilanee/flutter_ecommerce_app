// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ShippingAddressScreen extends StatefulWidget {
//   const ShippingAddressScreen({super.key});
//
//   @override
//   State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
// }
//
// class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _postalController = TextEditingController();
//
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserAddress();
//   }
//
//   Future<void> _loadUserAddress() async {
//     final String uid = FirebaseAuth.instance.currentUser!.uid;
//     final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//     final data = userDoc.data();
//     if (data != null) {
//       _nameController.text = data['name'] ?? '';
//       _phoneController.text = data['phone'] ?? '';
//       _addressController.text = data['fullAddress'] ?? '';
//       _cityController.text = data['city'] ?? '';
//       _districtController.text = data['district'] ?? '';
//       _countryController.text = data['country'] ?? '';
//       _postalController.text = data['postalCode'] ?? '';
//     }
//
//     setState(() => _loading = false);
//   }
//
//   Future<void> _updateAddress() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final String uid = FirebaseAuth.instance.currentUser!.uid;
//
//     await FirebaseFirestore.instance.collection('users').doc(uid).set({
//       "name": _nameController.text.trim(),
//       "phone": _phoneController.text.trim(),
//       "fullAddress": _addressController.text.trim(),
//       "city": _cityController.text.trim(),
//       "district": _districtController.text.trim(),
//       "country": _countryController.text.trim(),
//       "postalCode": _postalController.text.trim(),
//     }, SetOptions(merge: true));
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Address Updated Successfully!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Shipping Address"),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _buildTextField("Name", _nameController),
//               _buildTextField("Phone Number", _phoneController),
//               _buildTextField("Full Address", _addressController),
//               _buildTextField("City", _cityController),
//               _buildTextField("District", _districtController),
//               _buildTextField("Country", _countryController),
//               _buildTextField("Postal Code", _postalController),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateAddress,
//                 child: const Text("Save"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) =>
//         value!.isEmpty ? "$label cannot be empty" : null,
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> addresses = [];
  bool loading = true;

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();

  String? editingAddressId; // null = adding new

  @override
  void initState() {
    super.initState();
    _fetchUserAddresses();
  }

  Future<void> _fetchUserAddresses() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists && doc.data()!.containsKey("addresses")) {
      addresses = List<Map<String, dynamic>>.from(doc["addresses"]);
    }

    setState(() => loading = false);
  }

  void _editAddress(Map<String, dynamic>? address) {
    if (address != null) {
      editingAddressId = address["id"];
      _nameController.text = address["name"] ?? "";
      _phoneController.text = address["phone"] ?? "";
      _addressController.text = address["fullAddress"] ?? "";
      _cityController.text = address["city"] ?? "";
      _districtController.text = address["district"] ?? "";
      _countryController.text = address["country"] ?? "";
      _postalController.text = address["postalCode"] ?? "";
    } else {
      editingAddressId = null;
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _cityController.clear();
      _districtController.clear();
      _countryController.clear();
      _postalController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _buildForm(),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    var newAddress = {
      "id": editingAddressId ?? const Uuid().v4(),
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "fullAddress": _addressController.text.trim(),
      "city": _cityController.text.trim(),
      "district": _districtController.text.trim(),
      "country": _countryController.text.trim(),
      "postalCode": _postalController.text.trim(),
    };

    if (editingAddressId == null) {
      addresses.add(newAddress);
    } else {
      addresses = addresses.map((a) => a["id"] == editingAddressId ? newAddress : a).toList();
    }

    await FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .set({"addresses": addresses}, SetOptions(merge: true));

    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Address")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editAddress(null),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? const Center(child: Text("No Address Found"))
          : ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (_, i) {
          final a = addresses[i];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(a["fullAddress"]),
              subtitle: Text("${a["city"]},${a['district']} , ${a["country"]}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editAddress(a),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field("Name", _nameController),
              _field("Phone Number", _phoneController),
              _field("Full Address", _addressController),
              _field("City", _cityController),
              _field("District", _districtController),
              _field("Country", _countryController),
              _field("Postal Code", _postalController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAddress,
                child: Text(editingAddressId == null ? "Add Address" : "Save Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: (v) => v!.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
