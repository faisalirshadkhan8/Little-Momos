import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddressType = 'Home';
  String address = '123 Main St, City, 123456';
  String paymentMethod = '';
  String upiId = '';
  String cardNumber = '';
  String cardExpiry = '';
  String cardCvv = '';
  String promoCode = '';
  String deliveryNotes = '';
  bool isPromoExpanded = false;
  bool isPlacingOrder = false;
  String? errorMessage;

  final List<Map<String, dynamic>> orderItems = [
    {'name': 'Classic Veg Momo', 'quantity': 2},
    {'name': 'Chicken Momo', 'quantity': 1},
  ];
  final double subtotal = 390.0;
  final double deliveryFee = 30.0;
  final double tax = 19.5;
  double get total => subtotal + deliveryFee + tax;

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
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: [
                  // Delivery Information
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
                                'Delivery Information',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Edit address
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              for (var type in ['Home', 'Work', 'Other'])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(type),
                                    selected: selectedAddressType == type,
                                    selectedColor: const Color(0xFFF44336),
                                    backgroundColor: Colors.grey[200],
                                    onSelected: (_) {
                                      setState(() {
                                        selectedAddressType = type;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Payment Method
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
                            'Payment Method',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Cash',
                                groupValue: paymentMethod,
                                onChanged: (val) {
                                  setState(() {
                                    paymentMethod = val!;
                                    errorMessage = null;
                                  });
                                },
                                title: const Text('Cash on Delivery'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                              RadioListTile<String>(
                                value: 'Online Payment',
                                groupValue: paymentMethod,
                                onChanged: (val) {
                                  setState(() {
                                    paymentMethod = val!;
                                    errorMessage = null;
                                  });
                                },
                                title: const Text('Online Payment'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                              if (paymentMethod == 'Online Payment')
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    bottom: 8,
                                  ),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Online Payment ID',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) => upiId = val,
                                  ),
                                ),
                              RadioListTile<String>(
                                value: 'Card',
                                groupValue: paymentMethod,
                                onChanged: (val) {
                                  setState(() {
                                    paymentMethod = val!;
                                    errorMessage = null;
                                  });
                                },
                                title: const Text('Credit/Debit Card'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                              if (paymentMethod == 'Card')
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    bottom: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                          labelText: 'Card Number',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) => cardNumber = val,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Expiry',
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.datetime,
                                              onChanged:
                                                  (val) => cardExpiry = val,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'CVV',
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              obscureText: true,
                                              onChanged: (val) => cardCvv = val,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          if (errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Order Summary
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
                            'Order Summary',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...orderItems.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item['name']} x${item['quantity']}',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  // You can add per-item price here if needed
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
                  const SizedBox(height: 20),
                  // Promo Code
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'Apply Promo Code',
                        style: TextStyle(fontFamily: 'Roboto'),
                      ),
                      initiallyExpanded: isPromoExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isPromoExpanded = expanded;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Promo Code',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) => promoCode = val,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF44336),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: Apply promo code
                                },
                                child: const Text('Apply'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Delivery Notes
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
                            'Add Delivery Notes',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            minLines: 2,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Call on arrival',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) => deliveryNotes = val,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Sticky Place Order Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.transparent,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          textStyle: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed:
                            isPlacingOrder
                                ? null
                                : () async {
                                  if (paymentMethod.isEmpty) {
                                    setState(() {
                                      errorMessage =
                                          'Please select a payment method';
                                    });
                                    return;
                                  }
                                  setState(() {
                                    isPlacingOrder = true;
                                    errorMessage = null;
                                  });
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );
                                  setState(() {
                                    isPlacingOrder = false;
                                  });
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/order_confirmation',
                                  );
                                },
                        child:
                            isPlacingOrder
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                : Text(
                                  'Place Order ₹${total.toStringAsFixed(2)}',
                                ),
                      ),
                    ),
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
