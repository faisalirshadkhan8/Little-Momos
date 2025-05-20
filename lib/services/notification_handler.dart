import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../providers/order_status_provider.dart';
import '../services/notification_service.dart';

/// This class acts as a bridge between the NotificationService and OrderStatusProvider
class NotificationHandler {
  final NotificationService _notificationService;
  final OrderStatusProvider _orderStatusProvider;
  late StreamSubscription<RemoteMessage> _messageSubscription;

  NotificationHandler({
    required NotificationService notificationService,
    required OrderStatusProvider orderStatusProvider,
  }) : _notificationService = notificationService,
       _orderStatusProvider = orderStatusProvider {
    _init();
  }

  void _init() {
    // Listen to incoming notification messages
    _messageSubscription = _notificationService.messageStream.listen((
      RemoteMessage message,
    ) {
      _processMessage(message);
    });

    // Subscribe to the order updates topic
    _notificationService.subscribeToTopic('order_updates');
  }

  void _processMessage(RemoteMessage message) {
    try {
      // Check if the message is related to an order
      if (message.data.containsKey('orderId')) {
        debugPrint('Processing order notification: ${message.data}');

        // Handle the notification data in the order status provider
        _orderStatusProvider.handleNotificationData(message.data);
      }
    } catch (e) {
      debugPrint('Error processing notification message: $e');
    }
  }

  Future<void> saveUserToken(String userId) async {
    try {
      final token = await _notificationService.getToken();
      if (token != null) {
        await _notificationService.saveTokenToDatabase(userId, token);
      }
    } catch (e) {
      debugPrint('Error saving user token: $e');
    }
  }

  void dispose() {
    _messageSubscription.cancel();
  }
}
