// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'menu_item_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/menu_provider.dart'; // Add this import
import 'view_order_details_screen.dart';
import '../providers/cart_provider.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'All',
    'Classic Momos',
    'Pan Fried Momos',
    'Spicy Gravy Momos',
    'Creamy Momos',
    'Steak Sauce Momos',
    'Newly Launched Momos',
    'Noodles',
    'Soups',
    'Chinese Entrees',
    'Chilli Potato',
    'Beverages',
  ];
  int selectedCategory = 0;
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context); // Add this
    final cartProvider = Provider.of<CartProvider>(context); // Add this
    final cartCount = cartProvider.itemCount; // Use cart provider for count
    final userName = userProvider.name ?? 'User';
    final address = userProvider.address ?? 'No address set';
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Little Momo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.pushNamed(context, '/notification_history');
            },
          ),
        ],
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi $userName",
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Colors.orange[200],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      address,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Cart/Notification Icon
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              tooltip: 'Cart',
                              onPressed:
                                  () => Navigator.pushNamed(context, '/cart'),
                            ),
                            if (cartCount > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$cartCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white.withOpacity(0.10),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for momos, drinks, or combos…',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Roboto',
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFF44336),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Category Scroll
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, idx) {
                          final isSelected = idx == selectedCategory;
                          return ChoiceChip(
                            label: Text(
                              categories[idx],
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.brown[100],
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFFF44336),
                            backgroundColor: Colors.white.withOpacity(0.18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side:
                                  isSelected
                                      ? BorderSide.none
                                      : const BorderSide(
                                        color: Color(0xFF6a3c17),
                                        width: 1,
                                      ),
                            ),
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = idx;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Food Menu Section (Firestore)
                    StreamBuilder<List<Map<String, dynamic>>>(
                      // Use menuProvider instead of direct Firestore access
                      stream:
                          selectedCategory == 0
                              ? menuProvider.getMenuItemsStream()
                              : menuProvider.getMenuItemsByCategoryStream(
                                categories[selectedCategory],
                              ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No menu items found.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          );
                        }

                        final allItems = snapshot.data!;
                        final filteredItems = allItems;

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredItems.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            MenuItemDetailsScreen(item: item),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 6,
                                color: const Color(0xFF502f10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child:
                                            item['imageUrl'] != null &&
                                                    item['imageUrl']
                                                        .toString()
                                                        .isNotEmpty
                                                ? Image.network(
                                                  item['imageUrl'],
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.fastfood,
                                                        color: Colors.white54,
                                                        size: 40,
                                                      ),
                                                )
                                                : const Icon(
                                                  Icons.fastfood,
                                                  color: Colors.white54,
                                                  size: 40,
                                                ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'] ?? '',
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              item['desc'] ??
                                                  item['description'] ??
                                                  '',
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '₹${(item['price'] ?? 0).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Color(0xFFF44336),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFF44336,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 2,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Add to cart logic implementation
                                              final customItem = {
                                                ...item,
                                                'quantity': 1,
                                                'spiceLevel': 'Medium',
                                                'extraCheese': false,
                                                'totalPrice':
                                                    (item['price'] as num)
                                                        .toDouble(),
                                              };
                                              cartProvider.addToCart(
                                                customItem,
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Item added to cart',
                                                  ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                            label: const Text('Add'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              // Floating Cart Button
              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xFFF44336),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label:
                      cartCount > 0 ? Text('$cartCount') : const Text('Cart'),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
          textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall: const TextStyle(color: Colors.white),
            bodyMedium: const TextStyle(color: Colors.white),
            labelMedium: const TextStyle(color: Colors.white),
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
            onSurface: Colors.white,
            onPrimary: Colors.white,
            surface: const Color(0xFF4f2f11),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedNavIndex,
          onDestinationSelected: _onNavBarTap,
          height: 70,
          backgroundColor: const Color(0xFF4f2f11),
          indicatorColor: Colors.white.withOpacity(0.08),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    switch (index) {
      case 0:
        // Home: Already here
        break;
      case 1:
        // Orders
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewOrderDetailsScreen()),
        );
        break;
      case 2:
        // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
