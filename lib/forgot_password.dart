import 'package:flutter/material.dart';
class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Top header
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

            const SizedBox(height: 10),

            // Title
            Text(
              "Forget Password",
              style: TextStyle(
                fontSize: h * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            // Instructions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.1),
              child: Text(
                "Enter your registered email and we will send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h * 0.022,
                  color: Colors.grey[800],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Email text field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.07),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter Email",
                  hintText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Reset button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.25),
              child: Container(
                width: double.infinity,
                height: h * 0.08,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Send Reset Link",
                    style: TextStyle(
                      fontSize: h * 0.03,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Back to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Remember your password? "),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}