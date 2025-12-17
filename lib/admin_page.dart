import 'package:clothingapp/addproduct.dart';
import 'package:clothingapp/admin_profile.dart';
import 'package:clothingapp/listedproducts.dart';
import 'package:clothingapp/receivedorders.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:clothingapp/utils/my_flutter_app_icons.dart';
class adminpage extends StatefulWidget {
  const adminpage({super.key});

  @override
  State<adminpage> createState() => _adminpageState();
}

class _adminpageState extends State<adminpage> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    addproduct(),
    SellerProductsPage(),
    SellerOrdersPage(),
    ProfileScreenAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      // ⭐ GLASSMORPHIC BOTTOM NAV ⭐
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),  // glass transparency
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3), // smooth glass border
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(Icons.home, 0),
                navItem(Icons.stacked_line_chart, 1),
                navItem(Icons.call_received_outlined, 2),
                navItem(Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// ⭐ Custom Nav Item for Glass Bar
  Widget navItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => currentIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: isSelected ? 32 : 26,
          color: isSelected ? Colors.orange : Colors.white,
        ),
      ),
    );
  }
}





