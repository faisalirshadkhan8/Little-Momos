import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/order_service.dart';

class ViewOrderDetailsScreen extends StatefulWidget {
  const ViewOrderDetailsScreen({super.key});

  @override
  State<ViewOrderDetailsScreen> createState() => _ViewOrderDetailsScreenState();
}

class _ViewOrderDetailsScreenState extends State<ViewOrderDetailsScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _orderDetails;

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
      debugPrint("Received args: $args"); // Debug print to check arguments

      final orderId = args?['orderId'] as String?;
      debugPrint(
        "Extracted orderId: $orderId",
      ); // Debug print to check order ID

      if (orderId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Order ID not found in navigation arguments';
        });
        return;
      }

      // Fetch order details from Firestore
      debugPrint("Attempting to fetch order with ID: $orderId");
      final orderDetails = await _orderService.getOrderById(orderId);

      if (orderDetails.containsKey('error')) {
        debugPrint("Error from OrderService: ${orderDetails['error']}");
        setState(() {
          _isLoading = false;
          _errorMessage = orderDetails['error'];
        });
        return;
      }

      debugPrint(
        "Successfully fetched order details: ${orderDetails['orderId']}",
      );

      // Update state with order details
      setState(() {
        _orderDetails = orderDetails;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Exception in _fetchOrderDetails: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load order details: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching order details
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Order Details',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
          title: const Text(
            'Order Details',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
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
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Get order details from state
    final orderId = _orderDetails?['orderId'] ?? 'Unknown';
    final orderStatus = _orderDetails?['status'] ?? 'Unknown';
    final deliveryAddress =
        _orderDetails?['deliveryAddress'] ?? 'No address available';
    final addressType = _orderDetails?['addressType'] ?? 'Home';
    final paymentMethod = _orderDetails?['paymentMethod'] ?? 'Unknown';
    final paymentStatus = _orderDetails?['paymentStatus'] ?? 'Unknown';
    final paymentDetails = _orderDetails?['paymentDetails'];
    final List<dynamic> items = _orderDetails?['items'] ?? [];
    final subtotal = (_orderDetails?['subtotal'] as num?)?.toDouble() ?? 0.0;
    final deliveryFee =
        (_orderDetails?['deliveryFee'] as num?)?.toDouble() ?? 0.0;
    final tax = (_orderDetails?['tax'] as num?)?.toDouble() ?? 0.0;
    final total = (_orderDetails?['total'] as num?)?.toDouble() ?? 0.0;
    final promoDiscount =
        (_orderDetails?['promoDiscount'] as num?)?.toDouble() ?? 0.0;

    // Format creation time if available
    String orderDate = 'Unknown';
    if (_orderDetails?['createdAt'] != null) {
      try {
        final timestamp = _orderDetails!['createdAt'] as dynamic;
        final dateTime = timestamp.toDate();
        orderDate = DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
      } catch (e) {
        orderDate = 'Date not available';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4f2f11),
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Order Info Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID: $orderId',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(orderStatus)[0],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              orderStatus,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: _getStatusColor(orderStatus)[1],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        orderDate,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFFF44336),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deliveryAddress,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Address Type: $addressType',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.payment,
                            color: Color(0xFFF44336),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment: $paymentMethod',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                  ),
                                ),
                                if (paymentDetails != null)
                                  Text(
                                    paymentDetails,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                Row(
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            paymentStatus == 'Paid'
                                                ? Colors.green[100]
                                                : Colors.orange[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        paymentStatus,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              paymentStatus == 'Paid'
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Items Card
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
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  // Item image if available
                                  if (item['imageUrl'] != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['imageUrl'],
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.fastfood,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.fastfood,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  // Item details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? 'Unknown Item',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (item['spiceLevel'] != null)
                                          Text(
                                            'Spice: ${item['spiceLevel']}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        if (item['extraCheese'] == true)
                                          const Text(
                                            'Extra Cheese: Yes (+₹20)',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Item quantity and price
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${item['quantity']} × ₹${(item['price'] as num).toDouble()}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '₹${(item['totalPrice'] as num).toDouble()}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      const Divider(height: 24, thickness: 1),
                      // Price details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Delivery Fee',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${deliveryFee.toStringAsFixed(2)}',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tax',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹${tax.toStringAsFixed(2)}',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      if (promoDiscount > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Promo Discount',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              '-₹${promoDiscount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFFF44336),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Support/Help Card
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
                      const Text(
                        'Need Help?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          // TODO: Implement support contact
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.support_agent, color: Color(0xFFF44336)),
                            SizedBox(width: 12),
                            Text(
                              'Contact Support',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                      const Divider(height: 24),
                      InkWell(
                        onTap: () {
                          // TODO: Implement order cancellation if applicable
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.cancel_outlined, color: Colors.red),
                            SizedBox(width: 12),
                            Text(
                              'Request Cancellation',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to determine status color
  List<Color?> _getStatusColor(String status) {
    switch (status) {
      case 'Placed':
        return [Colors.blue[100], Colors.blue[800]];
      case 'Preparing':
        return [Colors.orange[100], Colors.orange[800]];
      case 'Out for Delivery':
        return [Colors.purple[100], Colors.purple[800]];
      case 'Delivered':
        return [Colors.green[100], Colors.green[800]];
      default:
        return [Colors.grey[100], Colors.grey[800]];
    }
  }
}
