import 'package:flutter/material.dart';

class ViewOrderDetailsScreen extends StatelessWidget {
  const ViewOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = '#LM1234';
    final orderStatus = 'Preparing';
    final deliveryAddress = '123 Main St, City, 123456';
    final paymentMethod = 'Cash on Delivery';
    final List<Map<String, dynamic>> items = [
      {'name': 'Classic Veg Momo', 'quantity': 2, 'price': 120},
      {'name': 'Chicken Momo', 'quantity': 1, 'price': 150},
    ];
    final double subtotal = 390.0;
    final double deliveryFee = 30.0;
    final double tax = 19.5;
    final double total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
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
                      Text(
                        'Order ID: $orderId',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.info, color: Color(0xFFF44336)),
                          const SizedBox(width: 8),
                          Text(
                            'Status: $orderStatus',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFFF44336),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              deliveryAddress,
                              style: const TextStyle(fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payment, color: Color(0xFFF44336)),
                          const SizedBox(width: 8),
                          Text(
                            'Payment: $paymentMethod',
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                        'Items',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item['name']} x${item['quantity']}',
                                  style: const TextStyle(fontFamily: 'Roboto'),
                                ),
                              ),
                              Text(
                                '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: const TextStyle(fontFamily: 'Roboto'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 20, thickness: 1),
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
            ],
          ),
        ),
      ),
    );
  }
}
