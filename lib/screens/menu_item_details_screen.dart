// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const MenuItemDetailsScreen({super.key, required this.item});

  @override
  State<MenuItemDetailsScreen> createState() => _MenuItemDetailsScreenState();
}

class _MenuItemDetailsScreenState extends State<MenuItemDetailsScreen> {
  int quantity = 1;
  String selectedSpice = 'Medium';
  bool extraCheese = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final cartProvider = Provider.of<CartProvider>(context);
    final double itemPrice =
        (item['price'] is int)
            ? (item['price'] as int).toDouble()
            : (item['price'] as num?)?.toDouble() ?? 0.0;
    final double totalPrice = itemPrice * quantity + (extraCheese ? 20.0 : 0.0);
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
                padding: EdgeInsets.zero,
                children: [
                  // Top Section: Image with overlay icons
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            item['imageUrl'] ??
                                'https://via.placeholder.com/400x300?text=No+Image',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: double.infinity,
                                  height: 220,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.fastfood,
                                    color: Colors.grey,
                                    size: 64,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: double.infinity,
                                height: 220,
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                    color: const Color(0xFFF44336),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 32,
                        left: 32,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Back',
                          ),
                        ),
                      ),
                      Positioned(
                        top: 32,
                        right: 32,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            tooltip: 'Favorite',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] ?? 'Menu Item',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Category chip
                        Chip(
                          label: Text(
                            item['category'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['description'] ?? 'No description available',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.92),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ingredients: ${item['ingredients'] ?? 'Not specified'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${itemPrice.toInt()}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFFF44336),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            // Quantity Selector
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.white,
                                  iconSize: 32,
                                  onPressed:
                                      quantity > 1
                                          ? () => setState(() => quantity--)
                                          : null,
                                  splashRadius: 24,
                                ),
                                Container(
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$quantity',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.white,
                                  iconSize: 32,
                                  onPressed: () => setState(() => quantity++),
                                  splashRadius: 24,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Option Modifiers
                        Text(
                          'Spice Level',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            for (var level in ['Mild', 'Medium', 'Hot'])
                              Row(
                                children: [
                                  Radio<String>(
                                    value: level,
                                    groupValue: selectedSpice,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedSpice = val!;
                                      });
                                    },
                                    activeColor: const Color(0xFFF44336),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    level,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          value: extraCheese,
                          onChanged: (val) {
                            setState(() {
                              extraCheese = val ?? false;
                            });
                          },
                          title: const Text(
                            'Add Extra Cheese (+₹20)',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          activeColor: const Color(0xFFF44336),
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
              // Sticky Add to Cart Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
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
                        onPressed: () {
                          // Add to cart with customizations
                          final orderItem = {
                            ...item,
                            'quantity': quantity,
                            'spiceLevel': selectedSpice,
                            'extraCheese': extraCheese,
                            'totalPrice': totalPrice,
                          };

                          cartProvider.addToCart(orderItem);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item['name']} added to cart'),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                              ),
                            ),
                          );
                        },
                        child: Text('Add to Cart ₹$totalPrice'),
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
