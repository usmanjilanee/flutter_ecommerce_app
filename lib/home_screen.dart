// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   final List<Map<String, dynamic>> products = const [
//     {"name": "Shoes", "price": 2500, "img": "assets/images/shoes.png"},
//     {"name": "Watch", "price": 3500, "img": "assets/images/watch.png"},
//     {"name": "Headphones", "price": 1500, "img": "assets/images/headphone.png"},
//     {"name": "Bag", "price": 2000, "img": "assets/images/bag.png"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("E-Commerce Store"),
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.orange,
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(12),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.72,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           return ProductCard(
//             name: products[index]['name'],
//             price: products[index]['price'],
//             img: products[index]['img'],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final String name;
//   final int price;
//   final String img;
//
//   const ProductCard({
//     super.key,
//     required this.name,
//     required this.price,
//     required this.img,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5,
//             spreadRadius: 1,
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             flex: 7,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(img, fit: BoxFit.contain),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 Text(
//                   "Rs $price",
//                   style: const TextStyle(
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15),
//                 ),
//                 const SizedBox(height: 5),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text("Add to Cart"),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:clothingapp/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'addtocart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce Store"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products') // your collection name
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }
          //var w = MediaQuery.of(context).size.width*1.14;
          //double cAC = w/2;
          final products = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //crossAxisCount: cAC.toInt(),
              crossAxisCount: 2,
              childAspectRatio:0.76, //w/MediaQuery.of(context).size.height*0.76, //0.55,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              String title = product['title'];
              List images = product['images'];
              List variants = product['variants'];
              String productid = products[index].id;

              // First variant price to show
              int price = variants.isNotEmpty ? variants[0]['price'] : 0;

              return ProductCard(
                name: title,
                price: price,
                imgUrl: images.isNotEmpty ? images[0] : "",
                productid: productid,
              );
            },
          );
        },
      ),
    );
  }
}
class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String imgUrl;
  final String? productid;

  const ProductCard({
    super.key,
    required this.productid,
    required this.name,
    required this.price,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: imgUrl.isEmpty
                  ? const Center(child: Icon(Icons.image_not_supported))
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                            (context)=>ProductDetailScreen(productId: productid!)));
                      },
                      child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                    ),
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,overflow: TextOverflow.ellipsis,textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      Text(
                        "Rs $price",
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      Spacer(),
                      InkWell(onTap: (){CartService().addToCart(context, productid!);},child: Icon(Icons.add_shopping_cart_outlined,color: Colors.orange,))
                    ],
                  ),
                  //SizedBox(height: 2,),
                  // LayoutBuilder(
                  //   builder: (context , constraints){
                  //     final double horizontalPadding = constraints.maxWidth*0.4;
                  //   return Padding(
                  //     padding: EdgeInsets.only(left:  horizontalPadding,),
                  //     child: ElevatedButton(
                  //       onPressed: () {CartService().addToCart(context, productid!);},
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.orange,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //       ),
                  //           child: const Icon(Icons.add_shopping_cart_outlined,color: Colors.orange,)//Text("Add to Cart", textAlign: TextAlign.center,)
                  //     ),
                  //   );}
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
