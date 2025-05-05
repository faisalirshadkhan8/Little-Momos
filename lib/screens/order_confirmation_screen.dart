// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int currentStep = 1; // 0: Received, 1: Preparing, 2: Out, 3: Delivered
  final String orderId = '#LM1234';
  final String deliveryAddress = '123 Main St, City, 123456';
  final String estimatedTime = 'Arriving in 25–30 minutes';
  final Map<String, String> riderInfo = {
    'name': 'Ravi Sharma',
    'phone': '+91 98765 43210',
    'photo': '', // Add asset path or leave empty for icon
  };

  final List<Map<String, dynamic>> steps = [
    {'title': 'Order Received', 'icon': Icons.check_circle, 'emoji': '✅'},
    {'title': 'Preparing', 'icon': Icons.restaurant, 'emoji': '🍳'},
    {'title': 'Out for Delivery', 'icon': Icons.delivery_dining, 'emoji': '🚚'},
    {'title': 'Delivered', 'icon': Icons.celebration, 'emoji': '🎉'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4f2f11), Color(0xFF6a3c17)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
            children: [
              // Success Icon & Heading
              Center(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: const Color(0xFFF44336),
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Order Confirmed!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your delicious momos are being prepared.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order ID: $orderId',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Tracking Timeline
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < steps.length; i++)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        i <= currentStep
                                            ? const Color(0xFFF44336)
                                            : Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      steps[i]['emoji'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                if (i < steps.length - 1)
                                  Container(
                                    width: 4,
                                    height: 36,
                                    color:
                                        i < currentStep
                                            ? const Color(0xFFF44336)
                                            : Colors.grey[300],
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                steps[i]['title'],
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color:
                                      i == currentStep
                                          ? const Color(0xFFF44336)
                                          : Colors.black87,
                                  fontWeight:
                                      i == currentStep
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Estimated Time & Delivery Info
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Color(0xFFF44336)),
                          const SizedBox(width: 8),
                          Text(
                            estimatedTime,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFFF44336),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              deliveryAddress,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          if (currentStep <= 1)
                            TextButton(
                              onPressed: () {
                                // TODO: Edit address
                              },
                              child: const Text('Edit'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Rider Info (Optional)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        child:
                            riderInfo['photo']!.isEmpty
                                ? const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.grey,
                                )
                                : null, // Add image if available
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              riderInfo['name']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Delivery Partner',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.call, color: Color(0xFFF44336)),
                        onPressed: () {
                          // TODO: Call rider
                        },
                        tooltip: 'Call',
                        splashRadius: 28,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Color(0xFFF44336),
                        ),
                        onPressed: () {
                          // TODO: Message rider
                        },
                        tooltip: 'Message',
                        splashRadius: 28,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF44336),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size.fromHeight(56),
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/order_details');
                      },
                      child: const Text('View Order Details'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF44336),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size.fromHeight(56),
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      child: const Text('Back to Home'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
