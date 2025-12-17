// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class CartPage extends StatefulWidget {
//   const CartPage({super.key});
//
//   @override
//   State<CartPage> createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//   final user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Cart")),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final userData = snapshot.data!.data() as Map<String, dynamic>?;
//
//           if (userData == null || !userData.containsKey("cart") || userData["cart"].isEmpty) {
//             return const Center(child: Text("Your cart is empty"));
//           }
//
//           final List cart = userData["cart"];
//
//           // Group by seller name
//           Map<String, List> grouped = {};
//           for (var item in cart) {
//             String seller = item["sellerName"];
//             grouped.putIfAbsent(seller, () => []);
//             grouped[seller]!.add(item);
//           }
//
//           double total = 0;
//           for (var item in cart) {
//             total += (item["variantPrice"] * item["quantity"]);
//           }
//
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   children: grouped.entries.map((entry) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text(
//                             entry.key,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         ...entry.value.map((item) {
//                           return Card(
//                             margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                             child: ListTile(
//                               leading: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(
//                                   item["productData"]["images"],
//                                   width: 60,
//                                   height: 60,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               title: Text(item["productData"]["title"]),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Variant: ${item["variant"]}"),
//                                   Text("Price: ${item["variantPrice"]} PKR"),
//                                 ],
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.remove),
//                                     onPressed: () => _updateQty(item, -1),
//                                   ),
//                                   Text("${item['quantity']}"),
//                                   IconButton(
//                                     icon: const Icon(Icons.add),
//                                     onPressed: () => _updateQty(item, 1),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//
//               /// Bottom Summary Box
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(15)),
//                   color: Colors.blueGrey.shade100,
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Total: ${total.toStringAsFixed(0)} PKR",
//                       style: const TextStyle(
//                         fontSize: 21,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 45),
//                       ),
//                       child: const Text("Proceed to Checkout"),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _updateQty(dynamic item, int change) async {
//     final userRef =
//     FirebaseFirestore.instance.collection('users').doc(user!.uid);
//
//     DocumentSnapshot userDoc = await userRef.get();
//     List cart = userDoc["cart"];
//
//     int index = cart.indexOf(item);
//     cart[index]["quantity"] =
//         (cart[index]["quantity"] + change).clamp(1, 100);
//
//     await userRef.update({"cart": cart});
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null || !userData.containsKey("cart") || userData["cart"].isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          final List cart = userData["cart"];

          // Group by seller name
          Map<String, List> grouped = {};
          for (var item in cart) {
            String seller = item["sellerName"];
            grouped.putIfAbsent(seller, () => []);
            grouped[seller]!.add(item);
          }

          // Calculate total
          double total = 0;
          for (var item in cart) {
            total += (item["variantPrice"] * item["quantity"]);
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: grouped.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...entry.value.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item["productData"]["images"],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(item["productData"]["title"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Variant: ${item["variant"]}"),
                                  Text("Price: ${item["variantPrice"]} PKR"),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeItem(item),
                                  ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => _updateQty(item, -1),
                                      ),
                                      Text("${item['quantity']}"),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => _updateQty(item, 1),
                                      ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // Bottom Total Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Column(
                  children: [
                    Text(
                      "Total: ${total.toStringAsFixed(0)} PKR",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>CheckoutPage(total: total,)));},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 46)),
                      child: const Text("Proceed to Checkout"),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Future<void> _updateQty(dynamic item, int change) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    DocumentSnapshot userDoc = await userRef.get();
    List cart = List.from(userDoc["cart"]);

    // Find by productId + variant
    int index = cart.indexWhere((cartItem) =>
    cartItem["productId"] == item["productId"] &&
        cartItem["variant"] == item["variant"]);

    if (index == -1) return; // item not found

    int newQty = cart[index]["quantity"] + change;

    if (newQty <= 0) {
      cart.removeAt(index);
    } else {
      cart[index]["quantity"] = newQty;
    }

    await userRef.update({"cart": cart});
  }
  
  
  Future<void> _removeItem(dynamic item) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    DocumentSnapshot userDoc = await userRef.get();
    List cart = List.from(userDoc["cart"]);

    cart.removeWhere((cartItem) =>
    cartItem["productId"] == item["productId"] &&
        cartItem["variant"] == item["variant"]);

    await userRef.update({"cart": cart});
  }
}
