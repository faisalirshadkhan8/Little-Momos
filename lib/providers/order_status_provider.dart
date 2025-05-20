import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_notification.dart';

class OrderStatusProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<OrderNotification> _notifications = [];

  List<OrderNotification> get notifications => _notifications;

  // Method to fetch user's order notifications
  Future<void> fetchNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .get();

      _notifications =
          snapshot.docs
              .map((doc) => OrderNotification.fromJson(doc.data()))
              .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    }
  }

  // Method to add a new notification
  Future<void> addNotification(OrderNotification notification) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .add(notification.toJson());

      _notifications.insert(0, notification);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding notification: $e');
    }
  }

  // Method to handle incoming push notification
  void handleNotificationData(Map<String, dynamic> data) {
    try {
      String message = data['message'] ?? 'Your order status has changed';
      String status = data['status'] ?? 'unknown';

      // Check if the order is out for delivery
      if (status == 'out_for_delivery') {
        message = 'You will receive your order in maximum 15 minutes';
      }

      // Create notification from push data
      final notification = OrderNotification(
        orderId: data['orderId'] ?? '',
        title: data['title'] ?? 'Order Update',
        message: message,
        status: status,
        timestamp: DateTime.now(),
      );

      // Add to list and database
      addNotification(notification);
    } catch (e) {
      debugPrint('Error handling notification data: $e');
    }
  }

  // Clear all notifications
  Future<void> clearNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('notifications')
              .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      _notifications.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }
}
