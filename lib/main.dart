import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_item_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/view_order_details_screen.dart';
import 'screens/contact_location_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notification_history_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/order_status_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'services/notification_service.dart' show globalNavigatorKey;
import 'services/notification_handler.dart';
import 'services/user_token_manager.dart';

// This needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you initialize the service before using it.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Initialize notification service
  final notificationService = NotificationService();
  final orderStatusProvider = OrderStatusProvider();
  final userTokenManager = UserTokenManager();

  // Initialize notification handler
  final notificationHandler = NotificationHandler(
    notificationService: notificationService,
    orderStatusProvider: orderStatusProvider,
  );

  // Set up token refresh listener
  userTokenManager.setupTokenRefreshListener();

  runApp(
    MyApp(
      notificationService: notificationService,
      orderStatusProvider: orderStatusProvider,
      notificationHandler: notificationHandler,
      userTokenManager: userTokenManager,
    ),
  );
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  final OrderStatusProvider orderStatusProvider;
  final NotificationHandler notificationHandler;
  final UserTokenManager userTokenManager;

  const MyApp({
    super.key,
    required this.notificationService,
    required this.orderStatusProvider,
    required this.notificationHandler,
    required this.userTokenManager,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider.value(value: orderStatusProvider),
        Provider.value(value: notificationService),
        Provider.value(value: notificationHandler),
        Provider.value(value: userTokenManager),
      ],
      child: MaterialApp(
        title: 'Little Momo',
        navigatorKey: globalNavigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/menu_item_details': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return MenuItemDetailsScreen(item: args);
          },
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order_confirmation': (context) => const OrderConfirmationScreen(),
          '/order_details': (context) => const ViewOrderDetailsScreen(),
          '/contact': (context) => const ContactLocationScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/notification_history':
              (context) => const NotificationHistoryScreen(),
        },
      ),
    );
  }
}
