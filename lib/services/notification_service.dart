import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // For handling notification when the app is in terminated state
  final _messageStreamController = StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  // Constructor
  NotificationService() {
    _initializeNotifications();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    // Request permission for iOS devices
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response.payload);
      },
    ); // Create Android notification channels
    const AndroidNotificationChannel
    generalChannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    const AndroidNotificationChannel deliveryChannel =
        AndroidNotificationChannel(
          'delivery_channel', // id
          'Delivery Notifications', // title
          description:
              'This channel is used for delivery notifications.', // description
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        );

    final androidNotificationPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidNotificationPlugin?.createNotificationChannel(generalChannel);
    await androidNotificationPlugin?.createNotificationChannel(deliveryChannel);

    // Set up handlers for different app states
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);
    _firebaseMessaging.getInitialMessage().then(_handleTerminatedTap);

    // Set up a background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    // Check if this is an order delivery notification
    if (message.data.containsKey('status') &&
        message.data['status'] == 'out_for_delivery' &&
        message.data.containsKey('orderId')) {
      // Create a custom notification body for delivery
      _showDeliveryNotification(
        message.data['orderId'] ?? '',
        'Order Out for Delivery',
        'You will receive your order in maximum 15 minutes',
        message.data,
      );

      // Emit the message for any listeners
      _messageStreamController.add(message);
    }
    // For regular notifications
    else {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Show a local notification
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              icon: android.smallIcon,
            ),
          ),
          payload: message.data.toString(),
        );
      }

      // Emit the message for any listeners
      _messageStreamController.add(message);
    }
  }

  // Show a special delivery notification
  void _showDeliveryNotification(
    String orderId,
    String title,
    String body,
    Map<String, dynamic> data,
  ) {
    _flutterLocalNotificationsPlugin.show(
      orderId.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'delivery_channel',
          'Delivery Notifications',
          channelDescription:
              'This channel is used for delivery notifications.',
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          enableLights: true,
        ),
      ),
      payload: data.toString(),
    );
  }

  // Handle when user taps on notification when app is in background
  void _handleBackgroundTap(RemoteMessage message) {
    debugPrint('Notification clicked from background: ${message.data}');
    _messageStreamController.add(message);
  }

  // Handle when user taps on notification when app is terminated
  void _handleTerminatedTap(RemoteMessage? message) {
    if (message != null) {
      debugPrint('Notification clicked from terminated state: ${message.data}');
      _messageStreamController.add(message);
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.contains('orderId')) {
      final orderId = _extractOrderIdFromPayload(payload);
      if (orderId != null) {
        globalNavigatorKey.currentState?.pushNamed(
          '/view_order_details',
          arguments: {'orderId': orderId},
        );
      }
    }
  }

  String? _extractOrderIdFromPayload(String payload) {
    try {
      final data = payload.contains('{') ? payload : '{}';
      final Map<String, dynamic> map = Map<String, dynamic>.from(
        (data.isNotEmpty)
            ? (data.startsWith('{')
                ? (data.endsWith('}')
                    ? (data.length > 2
                        ? Map<String, dynamic>.from(jsonDecode(data))
                        : {})
                    : {})
                : {})
            : {},
      );
      return map['orderId']?.toString();
    } catch (_) {
      return null;
    }
  }

  // Subscribe to a topic for receiving broadcast messages
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Get FCM token for this device
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Save FCM token to database
  Future<void> saveTokenToDatabase(String userId, String token) async {
    // Here you would typically save the token to your database
    // For example using Firestore:
    // await FirebaseFirestore.instance
    //    .collection('users')
    //    .doc(userId)
    //    .update({'fcmToken': token});
    debugPrint('Saving token for user $userId: $token');
  }

  // Dispose resources
  void dispose() {
    _messageStreamController.close();
  }
}

// This needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you initialize the service before using it.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Handling a background message: ${message.messageId}');
}
