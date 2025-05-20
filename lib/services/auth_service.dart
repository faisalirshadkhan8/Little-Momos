import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/user_token_manager.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Sign up with email, password, and name
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String address,
    required String phone,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();

        // Save user info to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'address': address,
          'phone': phone,
          'fcmTokens': [], // Initialize empty FCM tokens array
          'createdAt': FieldValue.serverTimestamp(),
          'notificationSettings': {
            'orderUpdates': true,
            'promotions': true,
            'deliveryAlerts': true,
          },
        });
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getMessageFromErrorCode(e.code);
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getMessageFromErrorCode(e.code);
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  // Helper: Map Firebase error codes to user-friendly messages
  String _getMessageFromErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return 'Authentication error: $code';
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
