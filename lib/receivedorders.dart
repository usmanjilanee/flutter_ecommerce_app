import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SellerOrdersPage extends StatefulWidget {
  const SellerOrdersPage({super.key});

  @override
  State<SellerOrdersPage> createState() => _SellerOrdersPageState();
}

class _SellerOrdersPageState extends State<SellerOrdersPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // Filter orders that belong to THIS seller
          final sellerOrders = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final items = List.from(data["items"] ?? []);
            return items.any((item) => item["sellerId"] == user!.uid);
          }).toList();

          if (sellerOrders.isEmpty) {
            return const Center(child: Text("No orders found for you"));
          }

          return ListView.builder(
            itemCount: sellerOrders.length,
            itemBuilder: (context, index) {
              final orderDoc = sellerOrders[index];
              final orderId = orderDoc.id;
              final data = orderDoc.data() as Map<String, dynamic>;

              final List items = data["items"];
              final customerAddress = data["address"];
              final paymentMethod = data["paymentMethod"];
              final orderStatus = data["status"];
              final orderTime = data["orderTime"] as Timestamp;

              // Filter only the items from this seller
              final sellerItems = items.where((item) =>
              item["sellerId"] == user!.uid).toList();

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ORDER HEADER
                      Text(
                        "Order ID: $orderId",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      // EACH PRODUCT OF THE SELLER
                      ...sellerItems.map((item) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item["productData"]["images"],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(item["productData"]["title"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Variant: ${item["variant"]}"),
                                      Text(
                                          "Price: ${item["variantPrice"]} PKR"),
                                      Text("Qty: ${item["quantity"]}"),
                                    ],
                                  ),
                                )
                              ],
                            ),

                            const Divider(height: 25),
                          ],
                        );
                      }).toList(),

                      // CUSTOMER DETAILS
                      Text(
                        "Customer Address:",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("${customerAddress['name']}"),
                      Text("${customerAddress['phone']}"),
                      Text("${customerAddress['fullAddress']}"),
                      Text(
                          "${customerAddress['city']}, ${customerAddress['district']}, ${customerAddress['country']}"),
                      Text("Postal Code: ${customerAddress['postalCode']}"),

                      const SizedBox(height: 12),

                      // PAYMENT
                      Text(
                        "Payment: $paymentMethod",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      // ORDER DATE
                      Text(
                        "Order Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(orderTime.toDate())}",
                        style: const TextStyle(),
                      ),

                      const SizedBox(height: 12),

                      // STATUS DROPDOWN
                      Row(
                        children: [
                          const Text(
                            "Status:",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 10),

                          DropdownButton<String>(
                            value: orderStatus,
                            items: [
                              "Pending",
                              "Shipped",
                              "Completed",
                              "Canceled"
                            ].map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              await FirebaseFirestore.instance
                                  .collection("orders")
                                  .doc(orderId)
                                  .update({"status": value});

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Status updated")),
                              );
                            },
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
    );
  }
}

