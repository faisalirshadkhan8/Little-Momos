// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _orderDetails;

  int currentStep = 0; // 0: Received, 1: Preparing, 2: Out, 3: Delivered

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
  void initState() {
    super.initState();
    // Fetch order details after widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    try {
      // Get order ID from arguments
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final orderId = args?['orderId'] as String?;

      if (orderId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Order ID not found';
        });
        return;
      }

      // Fetch order details from Firestore
      final orderDetails = await _orderService.getOrderById(orderId);

      if (orderDetails.containsKey('error')) {
        setState(() {
          _isLoading = false;
          _errorMessage = orderDetails['error'];
        });
        return;
      }

      // Update state with order details
      setState(() {
        _orderDetails = orderDetails;
        _isLoading = false;

        // Set current step based on order status
        switch (orderDetails['status']) {
          case 'Placed':
            currentStep = 0;
            break;
          case 'Preparing':
            currentStep = 1;
            break;
          case 'Out for Delivery':
            currentStep = 2;
            break;
          case 'Delivered':
            currentStep = 3;
            break;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load order details: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show loading indicator while fetching order details
    if (_isLoading) {
      return Scaffold(
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
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    // Show error message if something went wrong
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmation'),
          backgroundColor: const Color(0xFF4f2f11),
          foregroundColor: Colors.white,
        ),
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Order',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4f2f11),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  child: const Text('Return to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Format the estimated delivery time
    final estimatedDelivery =
        _orderDetails?['estimatedDelivery'] != null
            ? (_orderDetails!['estimatedDelivery'] as dynamic).toDate()
            : DateTime.now().add(const Duration(minutes: 45));

    final formatter = DateFormat('h:mm a');
    final estimatedTimeFormatted = formatter.format(estimatedDelivery);

    // Calculate estimated minutes remaining
    final minutesRemaining =
        estimatedDelivery.difference(DateTime.now()).inMinutes;
    final estimatedTimeText =
        minutesRemaining > 0
            ? 'Arriving in about $minutesRemaining minutes (by $estimatedTimeFormatted)'
            : 'Expected delivery by $estimatedTimeFormatted';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4f2f11),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFFF44336),
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
                      'Order ID: ${_orderDetails?['orderId'] ?? 'Unknown'}',
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
                          Expanded(
                            child: Text(
                              estimatedTimeText,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _orderDetails?['deliveryAddress'] ??
                                      'No address available',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Address Type: ${_orderDetails?['addressType'] ?? 'Home'}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'Roboto',
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_orderDetails?['deliveryNotes'] != null &&
                          _orderDetails!['deliveryNotes'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.note,
                                color: Color(0xFFF44336),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Note: ${_orderDetails!['deliveryNotes']}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Payment Info
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
                      Text(
                        'Payment Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Method:',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            _orderDetails?['paymentMethod'] ?? 'N/A',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (_orderDetails?['paymentDetails'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Details:',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              Text(
                                _orderDetails!['paymentDetails'],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount:',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            '₹${_orderDetails?['total']?.toStringAsFixed(2) ?? '0.00'}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF44336),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status:',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _orderDetails?['paymentStatus'] == 'Paid'
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _orderDetails?['paymentStatus'] ?? 'Unknown',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color:
                                    _orderDetails?['paymentStatus'] == 'Paid'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
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
              // Rider Info
              if (currentStep >= 2)
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
                          icon: const Icon(
                            Icons.call,
                            color: Color(0xFFF44336),
                          ),
                          onPressed: () {
                            // Call rider
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
                            // Message rider
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
                        Navigator.pushNamed(
                          context,
                          '/order_details',
                          arguments: {'orderId': _orderDetails?['orderId']},
                        );
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
