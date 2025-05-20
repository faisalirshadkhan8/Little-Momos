// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderService _orderService = OrderService();
  String selectedAddressType = 'Home';
  String? address;
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
  final double deliveryFee = 30.0;
  final double taxRate = 0.05; // 5%

  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set initial address from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.address != null && userProvider.address!.isNotEmpty) {
        setState(() {
          address = userProvider.address;
          _addressController.text = userProvider.address ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final cartItems = cartProvider.items;

    // Calculate order totals from real cart data
    final subtotal = cartProvider.totalAmount;
    final tax = subtotal * taxRate;
    final total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
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
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
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
                                    _showAddressEditDialog(
                                      context,
                                      userProvider,
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address ?? 'No address set - please add one',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Roboto',
                                color: address == null ? Colors.red : null,
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
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Online Payment ID',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator:
                                          paymentMethod == 'Online Payment'
                                              ? (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a payment ID';
                                                }
                                                return null;
                                              }
                                              : null,
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
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Card Number',
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator:
                                              paymentMethod == 'Card'
                                                  ? (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter card number';
                                                    }
                                                    return null;
                                                  }
                                                  : null,
                                          onChanged: (val) => cardNumber = val,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText:
                                                          'Expiry (MM/YY)',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                keyboardType:
                                                    TextInputType.datetime,
                                                validator:
                                                    paymentMethod == 'Card'
                                                        ? (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Required';
                                                          }
                                                          return null;
                                                        }
                                                        : null,
                                                onChanged:
                                                    (val) => cardExpiry = val,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'CVV',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                keyboardType:
                                                    TextInputType.number,
                                                obscureText: true,
                                                validator:
                                                    paymentMethod == 'Card'
                                                        ? (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Required';
                                                          }
                                                          return null;
                                                        }
                                                        : null,
                                                onChanged:
                                                    (val) => cardCvv = val,
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
                    // Order Summary with real cart data
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
                            ...cartItems.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${item['name']} x${item['quantity']}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '₹${item['totalPrice']}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
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
                                    // TODO: Implement promo code logic
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Promo code not valid'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
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
                                : () => _placeOrder(
                                  context,
                                  cartProvider,
                                  userProvider,
                                ),
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

  // Show address edit dialog
  void _showAddressEditDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Delivery Address'),
            content: TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Enter your full address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                ),
                onPressed: () {
                  setState(() {
                    address = _addressController.text;
                    // Update UserProvider with new address
                    if (userProvider.name != null) {
                      userProvider.updateUser(
                        name: userProvider.name!,
                        email: userProvider.email!,
                        address: _addressController.text,
                        phone: userProvider.phone ?? '',
                      );
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  // Place order method
  Future<void> _placeOrder(
    BuildContext context,
    CartProvider cartProvider,
    UserProvider userProvider,
  ) async {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Check if payment method is selected
    if (paymentMethod.isEmpty) {
      setState(() {
        errorMessage = 'Please select a payment method';
      });
      return;
    }

    // Check if address is set
    if (address == null || address!.isEmpty) {
      setState(() {
        errorMessage = 'Please add a delivery address';
      });
      return;
    }

    // Start placing order
    setState(() {
      isPlacingOrder = true;
      errorMessage = null;
    });

    // Prepare payment details
    String? paymentDetails;
    if (paymentMethod == 'Online Payment') {
      paymentDetails = upiId;
    } else if (paymentMethod == 'Card') {
      // Only store last 4 digits of card for safety
      if (cardNumber.length >= 4) {
        paymentDetails =
            'Card ending with ${cardNumber.substring(cardNumber.length - 4)}';
      }
    }

    try {
      // Create order in Firestore
      final result = await _orderService.createOrder(
        items: cartProvider.items,
        subtotal: cartProvider.totalAmount,
        deliveryFee: deliveryFee,
        tax: cartProvider.totalAmount * taxRate,
        total:
            cartProvider.totalAmount +
            deliveryFee +
            (cartProvider.totalAmount * taxRate),
        paymentMethod: paymentMethod,
        deliveryAddress: address!,
        addressType: selectedAddressType,
        deliveryNotes: deliveryNotes,
        promoCode: promoCode.isNotEmpty ? promoCode : null,
        paymentDetails: paymentDetails,
      );

      if (result['success'] == true) {
        // Clear cart after successful order
        cartProvider.clearCart();

        // Navigate to order confirmation screen with order ID
        Navigator.pushReplacementNamed(
          context,
          '/order_confirmation',
          arguments: {'orderId': result['orderId']},
        );
      } else {
        // Show error
        setState(() {
          isPlacingOrder = false;
          errorMessage = result['error'] ?? 'Failed to place order';
        });
      }
    } catch (e) {
      // Handle any errors
      setState(() {
        isPlacingOrder = false;
        errorMessage = e.toString();
      });
    }
  }
}
