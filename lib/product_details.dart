// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   final String productId;
//
//   const ProductDetailScreen({super.key, required this.productId});
//
//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   Map<String, dynamic>? product;
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProduct();
//   }
//
//   Future<void> fetchProduct() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('products')
//         .doc(widget.productId)
//         .get();
//
//     if (mounted) {
//       setState(() {
//         product = doc.data();
//         loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final images = List<String>.from(product!['images']);
//     final variants = List<Map<String, dynamic>>.from(product!['variants']);
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 // ---------------- PRODUCT IMAGES SLIDER ----------------
//                 SizedBox(
//                   height: 300, // reduced height
//                   child: PageView.builder(
//                     itemCount: images.length,
//                     itemBuilder: (context, index) {
//                       return Image.network(
//                         images[index],
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // ---------------- PRODUCT TITLE ----------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     product!['title'],
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // ---------------- PRODUCT PRICE ----------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Rs ${variants[0]['price']}",
//                         style: const TextStyle(
//                             fontSize: 20, color: Colors.black87),
//                       ),
//
//                       const SizedBox(width: 10),
//
//                       // BEST RATES TAG
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Text(
//                           "Best Rates",
//                           style: TextStyle(color: Colors.white, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // ---------------- FREE DELIVERY & RETURN ----------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(Icons.local_shipping, size: 20, color: Colors.green),
//                           SizedBox(width: 6),
//                           Text("Free Delivery", style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: const [
//                           Icon(Icons.refresh, size: 20, color: Colors.blue),
//                           SizedBox(width: 6),
//                           Text("05 Days Return", style: TextStyle(fontSize: 14)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // ---------------- SELLER INFO ----------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Seller Information",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         leading: CircleAvatar(
//                           backgroundImage: product!['sellerProfileImage'] == ""
//                               ? null
//                               : NetworkImage(product!['sellerProfileImage']),
//                           child: product!['sellerProfileImage'] == ""
//                               ? const Icon(Icons.person)
//                               : null,
//                         ),
//                         title: Text(product!['sellerName']),
//                         subtitle: Text(product!['sellerEmail']),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 100),
//               ],
//             ),
//           ),
//
//           // ---------------- ADD TO CART BUTTON (BOTTOM RIGHT) ----------------
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 "Add to Cart",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addtocart.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();

    if (mounted) {
      setState(() {
        product = doc.data();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final images = List<String>.from(product!['images']);
    final variants = List<Map<String, dynamic>>.from(product!['variants']);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Product'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  // ---------------- PRODUCT IMAGES SLIDER ----------------
                  SizedBox(
                    height: 300, // reduced height
                    child: PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          //fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
      
                  const SizedBox(height: 15),
      
                  // ---------------- PRODUCT TITLE ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      product!['title'],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
      
                  const SizedBox(height: 10),
      
                  // ---------------- PRODUCT PRICE + TAG ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Rs ${variants[0]['price']}",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black87),
                        ),
      
                        const SizedBox(width: 10),
      
                        // BEST RATES TAG
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Best Rates",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 15),
      
                  // ---------------- FREE DELIVERY & RETURN ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.local_shipping, size: 20, color: Colors.green),
                            SizedBox(width: 6),
                            Text("Free Delivery", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.refresh, size: 20, color: Colors.blue),
                            SizedBox(width: 6),
                            Text("05 Days Return", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 20),
      
                  // ---------------- SELLER INFO ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Seller Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: product!['sellerProfileImage'] == ""
                                ? null
                                : NetworkImage(product!['sellerProfileImage']),
                            child: product!['sellerProfileImage'] == ""
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(product!['sellerName']),
                          subtitle: Text(product!['sellerEmail']),
                        ),
      
                        const SizedBox(height: 20),
      
                        // ---------------- DESCRIPTION ----------------
                        const Text(
                          "Description",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
      
                        Text(
                          product!['description'] ?? "No description available.",
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                        ),
      
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 100),
                ],
              ),
            ),
            
      
            // ---------------- ADD TO CART BUTTON (BOTTOM RIGHT) ----------------
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {CartService().addToCart(context, widget.productId);},
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
