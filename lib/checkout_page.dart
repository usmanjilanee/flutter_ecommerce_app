import 'package:clothingapp/customer_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'roder_placed.dart';

class CheckoutPage extends StatefulWidget {
  final double total;
  const CheckoutPage({required this.total,super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState(total: total);
}

class _CheckoutPageState extends State<CheckoutPage> {
  double total;
  _CheckoutPageState({required this.total});
  final user = FirebaseAuth.instance.currentUser;
  int selectedAddressIndex = -1;
  String paymentMethod = "Cash on Delivery";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List cart = data["cart"] ?? [];
          final List<Map<String, dynamic>> addressList =
          List<Map<String, dynamic>>.from(data["addresses"] ?? []);

          if (cart.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Select Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // ADDRESS SELECTION
                Expanded(
                  child: ListView.builder(
                    itemCount: addressList.length,
                    itemBuilder: (context, index) {
                      final addr = addressList[index];

                      return RadioListTile(
                        value: index,
                        groupValue: selectedAddressIndex,
                        title: Text("${addr["name"]}, ${addr["fullAddress"]}"),
                        subtitle: Text(
                            "${addr["city"]}, ${addr["district"]}, ${addr["country"]}\nPhone: ${addr["phone"]}"),
                        onChanged: (val) {
                          setState(() => selectedAddressIndex = val!);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                RadioListTile(
                  value: "Cash on Delivery",
                  groupValue: paymentMethod,
                  title: const Text("Cash on Delivery"),
                  onChanged: (value) {
                    setState(() => paymentMethod = value.toString());
                  },
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () => _placeOrder(cart, addressList,total),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text("Place Order"),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _placeOrder(List cart, List addressList,double total) async {
    if (selectedAddressIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an address")),
      );
      return;
    }

    final selectedAddress = addressList[selectedAddressIndex];

    final orderData = {
      "userId": user!.uid,
      "items": cart,
      "address": selectedAddress,
      "paymentMethod": paymentMethod,
      "orderTime": FieldValue.serverTimestamp(),
      "status": "Pending",
    };

    try {
      // Save order in orders collection
      await FirebaseFirestore.instance.collection("orders").add(orderData);

      // Empty cart
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({"cart": []});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>orderplace(crt: cart,total:total)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}

