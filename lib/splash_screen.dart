import 'dart:async';
import 'package:clothingapp/admin_page.dart';
import 'package:clothingapp/customer_page.dart';
import 'package:flutter/material.dart';
import 'selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String text = "Wear SH";
  String animatedText = "";
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // Typing animation
    Timer.periodic(const Duration(milliseconds: 180), (timer) {
      if (currentIndex < text.length) {
        setState(() {
          animatedText += text[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel();
        // Go to login screen after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          checkLoginAndRole();
        });
      }
    });
  }
  Future<void> checkLoginAndRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, check role from Firestore
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'] ?? 'Customer';

          if (role == 'Admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => adminpage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => GlassBottomNavExample()),
            );
          }
        } else {
          // If user document doesn't exist, go to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AuthSelectionScreen()),
          );
        }
      } catch (e) {
        print("Error fetching role: $e");
        // In case of error, go to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AuthSelectionScreen()),
        );
      }
    } else {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthSelectionScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top decorative shape (matches your login theme)
          Container(
            width: w,
            height: h * 0.45,
            decoration: const BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Animated Text in Fade Transition
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              animatedText,
              style: TextStyle(
                color: Colors.orange.shade800,
                fontFamily: "MomoSignature",
                fontSize: h * 0.07,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
