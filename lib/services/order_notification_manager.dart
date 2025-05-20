import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderNotificationManager {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Subscribe to a specific order's updates
  Future<void> subscribeToOrderUpdates(String orderId) async {
    try {
      // Subscribe to the topic for this specific order
      await _messaging.subscribeToTopic('order_$orderId');
      debugPrint('Subscribed to updates for order: $orderId');
    } catch (e) {
      debugPrint('Error subscribing to order updates: $e');
    }
  }

  // Unsubscribe from a specific order's updates (e.g., after order is completed)
  Future<void> unsubscribeFromOrderUpdates(String orderId) async {
    try {
      await _messaging.unsubscribeFromTopic('order_$orderId');
      debugPrint('Unsubscribed from updates for order: $orderId');
    } catch (e) {
      debugPrint('Error unsubscribing from order updates: $e');
    }
  }

  // Update the notification preferences in Firestore
  Future<void> updateNotificationPreferences({
    required bool orderUpdates,
    required bool deliveryAlerts,
    required bool promotions,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'notificationSettings': {
          'orderUpdates': orderUpdates,
          'deliveryAlerts': deliveryAlerts,
          'promotions': promotions,
        },
      });

      // Subscribe or unsubscribe from general topics based on preferences
      if (orderUpdates) {
        await _messaging.subscribeToTopic('order_updates');
      } else {
        await _messaging.unsubscribeFromTopic('order_updates');
      }

      if (promotions) {
        await _messaging.subscribeToTopic('promotions');
      } else {
        await _messaging.unsubscribeFromTopic('promotions');
      }

      debugPrint('Notification preferences updated successfully');
    } catch (e) {
      debugPrint('Error updating notification preferences: $e');
    }
  }

  // Get current notification preferences
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'orderUpdates': true,
          'deliveryAlerts': true,
          'promotions': true,
        };
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      final settings = data?['notificationSettings'] as Map<String, dynamic>?;

      if (settings == null) {
        return {
          'orderUpdates': true,
          'deliveryAlerts': true,
          'promotions': true,
        };
      }

      return {
        'orderUpdates': settings['orderUpdates'] ?? true,
        'deliveryAlerts': settings['deliveryAlerts'] ?? true,
        'promotions': settings['promotions'] ?? true,
      };
    } catch (e) {
      debugPrint('Error getting notification preferences: $e');
      return {'orderUpdates': true, 'deliveryAlerts': true, 'promotions': true};
    }
  }
}
