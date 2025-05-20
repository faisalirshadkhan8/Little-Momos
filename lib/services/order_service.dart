import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Create a new order in Firestore
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
    required String paymentMethod,
    required String deliveryAddress,
    required String addressType,
    String? deliveryNotes,
    String? promoCode,
    String? paymentDetails,
  }) async {
    try {
      // Check if user is logged in
      if (_userId == null) {
        throw Exception('User not logged in');
      }

      // Get user data for order
      final userDoc = await _firestore.collection('users').doc(_userId).get();
      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Generate a unique order ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final orderId =
          'MOMO-${timestamp.toString().substring(timestamp.toString().length - 6)}';

      // Create the order object
      final orderData = {
        'orderId': orderId,
        'userId': _userId,
        'userName': userData['name'] ?? 'Guest',
        'userPhone': userData['phone'] ?? '',
        'userEmail': userData['email'] ?? '',
        'items': items,
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'tax': tax,
        'total': total,
        'paymentMethod': paymentMethod,
        'paymentDetails': paymentDetails,
        'paymentStatus': paymentMethod == 'Cash' ? 'Pending' : 'Paid',
        'deliveryAddress': deliveryAddress,
        'addressType': addressType,
        'deliveryNotes': deliveryNotes ?? '',
        'promoCode': promoCode,
        'promoDiscount': 0.0, // Add promo discount logic if needed
        'status': 'Placed',
        'createdAt': FieldValue.serverTimestamp(),
        'estimatedDelivery': Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 45)),
        ),
      };

      // Save order to Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);

      // Update user's order history
      await _firestore.collection('users').doc(_userId).update({
        'orders': FieldValue.arrayUnion([orderId]),
      });

      // Add order timestamp to user's activity
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('activity')
          .add({
            'type': 'order_placed',
            'orderId': orderId,
            'total': total,
            'timestamp': FieldValue.serverTimestamp(),
          });

      debugPrint('Order created successfully: $orderId');
      return {'success': true, 'orderId': orderId};
    } catch (e) {
      debugPrint('Error creating order: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Get order details by ID
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();

      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      return {'id': orderDoc.id, ...orderDoc.data()!};
    } catch (e) {
      debugPrint('Error getting order: $e');
      return {'error': e.toString()};
    }
  }

  // Get current user's orders
  Stream<List<Map<String, dynamic>>> getUserOrders() {
    if (_userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }
}
