import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
//
// class HomeNavigation extends StatefulWidget {
//   const HomeNavigation({super.key});
//
//   @override
//   State<HomeNavigation> createState() => _HomeNavigationState();
// }
//
// class _HomeNavigationState extends State<HomeNavigation> {
//   int index = 0;
//
//   final pages = const [
//     HomeScreen(),
//     CartScreen(),
//     OrdersScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[index],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: index,
//         onTap: (value) {
//           setState(() {
//             index = value;
//           });
//         },
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: "Cart"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.history), label: "Orders"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
import 'dart:ui';

class GlassBottomNavExample extends StatefulWidget {
  const GlassBottomNavExample({super.key});

  @override
  State<GlassBottomNavExample> createState() => _GlassBottomNavExampleState();
}

class _GlassBottomNavExampleState extends State<GlassBottomNavExample> {
  int currentIndex = 0;
  final List<Widget> pages =  [
    HomeScreen(),
    CartPage(),
    OrderHistoryPage(),
    ProfileScreen(),
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
                navItem(Icons.shopping_cart, 1),
                navItem(Icons.history, 2),
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

