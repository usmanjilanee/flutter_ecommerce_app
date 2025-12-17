// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class CartService {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   Future<void> addToCart(BuildContext context, String productId) async {
//     String uid = auth.currentUser!.uid;
//
//     try {
//       // Fetch product data from Firestore
//       DocumentSnapshot productSnap =
//       await firestore.collection('products').doc(productId).get();
//
//       if (!productSnap.exists) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Product not found")));
//         return;
//       }
//
//       Map<String, dynamic> productData =
//       productSnap.data() as Map<String, dynamic>;
//       List<dynamic> variants = productData["variants"] ?? [];
//
//       // Show BottomSheet for variant selection
//       showModalBottomSheet(
//         context: context,
//         builder: (context) => SizedBox(
//           height: 250,
//           child: ListView.builder(
//             itemCount: variants.length,
//             itemBuilder: (context, index) {
//               final selectedVariant = variants[index];
//               final variantName = selectedVariant["name"];
//               final variantPrice = selectedVariant["price"];
//               return ListTile(
//                 title: Text("$variantName - Rs $variantPrice"),
//                 onTap: () => _handleVariantSelection(
//                   context: context,
//                   uid: uid,
//                   productData: productData,
//                   productId: productId,
//                   selectedVariant: variantName,
//                   variantPrice: variantPrice,
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }
//
//   Future<void> _handleVariantSelection({
//     required BuildContext context,
//     required String uid,
//     required Map<String, dynamic> productData,
//     required String productId,
//     required String selectedVariant,
//     required int variantPrice,
//   }) async {
//     try {
//       DocumentReference userRef =
//       firestore.collection('users').doc(uid);
//
//       DocumentSnapshot userDoc = await userRef.get();
//       List<dynamic> cart = userDoc.data() != null
//           ? (userDoc["cart"] ?? [])
//           : [];
//
//       bool foundSameProduct = false;
//
//       for (int i = 0; i < cart.length; i++) {
//         if (cart[i]["productId"] == productId &&
//             cart[i]["variant"] == selectedVariant) {
//           cart[i]["quantity"] = (cart[i]["quantity"] ?? 1) + 1;
//           foundSameProduct = true;
//           break;
//         }
//       }
//
//       if (!foundSameProduct) {
//         Map<String,String> realproductdata = {
//           "title":productData["title"],
//           "category":productData["category"],
//           "images":productData["images"][0],
//
//         };
//         cart.add({
//           "productId": productId, // product id can be enough to fetch data at admin level
//           "variant": selectedVariant,
//           "variantPrice": variantPrice,
//           "quantity": 1,
//           "sellerId": productData["sellerId"],
//           "status": "pending",
//           "userId": uid,
//           "productData": realproductdata, // full snapshot if needed
//         });
//
//       }
//
//       await userRef.update({"cart": cart});
//
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Added to Cart")),
//       );
//     } catch (e) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addToCart(BuildContext context, String productId) async {
    String uid = auth.currentUser!.uid;

    try {
      DocumentSnapshot productSnap =
      await firestore.collection('products').doc(productId).get();

      if (!productSnap.exists) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Product not found")));
        return;
      }

      Map<String, dynamic> productData =
      productSnap.data() as Map<String, dynamic>;
      List<dynamic> variants = productData["variants"] ?? [];

      showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: variants.length,
            itemBuilder: (context, index) {
              final selectedVariant = variants[index];
              final variantName = selectedVariant["name"];
              final variantPrice = selectedVariant["price"];

              return ListTile(
                title: Text("$variantName - Rs $variantPrice"),
                onTap: () => _handleVariantSelection(
                  context: context,
                  uid: uid,
                  productData: productData,
                  productId: productId,
                  selectedVariant: variantName,
                  variantPrice: variantPrice,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _handleVariantSelection({
    required BuildContext context,
    required String uid,
    required Map<String, dynamic> productData,
    required String productId,
    required String selectedVariant,
    required int variantPrice,
  }) async {
    try {
      DocumentReference userRef = firestore.collection('users').doc(uid);
      DocumentSnapshot userDoc = await userRef.get();

      Map<String, dynamic>? userData =
      userDoc.data() as Map<String, dynamic>?;

      List<dynamic> cart = [];

      if (userData != null && userData.containsKey("cart")) {
        cart = List.from(userData["cart"]);
      }


      bool foundSameProduct = false;

      for (int i = 0; i < cart.length; i++) {
        if (cart[i]["productId"] == productId &&
            cart[i]["variant"] == selectedVariant) {
          cart[i]["quantity"] = (cart[i]["quantity"] ?? 1) + 1;
          foundSameProduct = true;
          break;
        }
      }

      if (!foundSameProduct) {
        Map<String, dynamic> realproductdata = {
          "title": productData["title"],
          "category": productData["category"],
          "images": productData["images"][0],
        };

        cart.add({
          "productId": productId,
          "variant": selectedVariant,
          "variantPrice": variantPrice,
          "quantity": 1,
          "sellerId": productData["sellerId"],
          "sellerName": productData["sellerName"],
          "status": "pending",
          "userId": uid,
          "productData": realproductdata,
        });
      }

      // 🔥 This fixes your issue: supports both update and create
      await userRef.set({
        "cart": cart,
      }, SetOptions(merge: true));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to Cart")),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}

