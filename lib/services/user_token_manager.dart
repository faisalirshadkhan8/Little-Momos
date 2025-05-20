import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserTokenManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Save the FCM token to Firestore for the current user
  Future<void> saveTokenToDatabase() async {
    try {
      // Check if user is logged in
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('Cannot save token: No user is logged in');
        return;
      }

      // Get the token for this device
      String? token = await _messaging.getToken();
      debugPrint('Attempting to save FCM token: $token for user: ${user.uid}');

      if (token == null) {
        debugPrint('FCM token is null. Token was not saved.');
        return;
      }

      // Save token with some metadata
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
            'fcmTokens': FieldValue.arrayUnion([
              {
                'token': token,
                'deviceType': _getPlatformType(),
                'lastUpdated': FieldValue.serverTimestamp(),
              },
            ]),
            'lastSeen': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .then((_) {
            debugPrint('FCM Token saved successfully for user: ${user.uid}');
          })
          .catchError((e) {
            debugPrint('Error updating Firestore with FCM token: $e');
          });
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  // Get the platform type
  String _getPlatformType() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ios';
    } else {
      return 'web';
    }
  }

  // Delete an old token from the database when logging out
  Future<void> removeTokenFromDatabase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      String? token = await _messaging.getToken();
      if (token == null) return;

      // Get the current tokens array
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return;

      List<dynamic> tokens = userDoc.data()?['fcmTokens'] ?? [];

      // Remove the current token
      tokens.removeWhere((item) => item['token'] == token);

      // Update the document
      await _firestore.collection('users').doc(user.uid).update({
        'fcmTokens': tokens,
      });

      debugPrint('FCM Token removed successfully for user: ${user.uid}');
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
    }
  }

  // Listen for token refreshes and save the updated token
  void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      saveTokenToDatabase();
    });
  }
}
