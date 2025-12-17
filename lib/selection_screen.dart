import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sign_up.dart';
class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top theme header
          Container(
            width: w,
            height: h * 0.35,
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
                width: w,
                height: h * 0.05,
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

          // Title
          Text(
            "Welcome",
            style: TextStyle(
              fontSize: h * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Text(
              "Please select an option to continue",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: h * 0.025, color: Colors.grey[700]),
            ),
          ),

          const SizedBox(height: 50),

          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Column(
              children: [
                // Login Button
                GestureDetector(
                  onTap: () {
                    // Navigate to your login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClothingMain(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: h * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: h * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                GestureDetector(
                  onTap: () {
                    // Navigate to your signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: h * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: h * 0.035,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}