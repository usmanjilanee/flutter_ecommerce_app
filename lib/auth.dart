import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Create User in Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save User Detail & Role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'uid': userCredential.user!.uid,
        'createdAt': DateTime.now(),
      });

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Something went wrong!";
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch(e){
      return null;
    }
    }}