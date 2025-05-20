import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_token_manager.dart';

class UserProvider extends ChangeNotifier {
  String? uid;
  String? name;
  String? email;
  String? address;
  String? phone;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserTokenManager? _tokenManager;

  set tokenManager(UserTokenManager manager) {
    _tokenManager = manager;
  }

  bool get isLoggedIn => uid != null && email != null;

  // Initialize user data from Firebase Auth
  Future<void> initUserFromAuth() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      email = currentUser.email;

      try {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          name = userData?['name'];
          address = userData?['address'];
          phone = userData?['phone'];
        }

        // Save the token once user is logged in
        if (_tokenManager != null) {
          await _tokenManager!.saveTokenToDatabase();
        }

        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  // Update user data
  Future<void> updateUser({
    required String name,
    required String email,
    required String address,
    required String phone,
  }) async {
    this.name = name;
    this.email = email;
    this.address = address;
    this.phone = phone;

    if (uid != null) {
      try {
        await _firestore.collection('users').doc(uid).update({
          'name': name,
          'email': email,
          'address': address,
          'phone': phone,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint('Error updating user data: $e');
      }
    }

    notifyListeners();
  }

  // Logout user
  Future<void> logout() async {
    try {
      if (_tokenManager != null) {
        await _tokenManager!.removeTokenFromDatabase();
      }

      await _auth.signOut();

      uid = null;
      name = null;
      email = null;
      address = null;
      phone = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
