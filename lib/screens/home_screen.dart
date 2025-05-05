// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'menu_item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'All',
    'Veg',
    'Chicken',
    'Spicy',
    'Beverages',
  ];
  int selectedCategory = 0;
  int _selectedTab = 0;

  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Classic Veg Momo',
      'desc': 'Steamed momos stuffed with fresh veggies.',
      'price': 120,
      'image': 'assets/food/veg_momo.png',
    },
    {
      'name': 'Chicken Momo',
      'desc': 'Juicy chicken filling, served hot.',
      'price': 150,
      'image': 'assets/food/chicken_momo.png',
    },
    {
      'name': 'Spicy Schezwan Momo',
      'desc': 'Momos tossed in spicy Schezwan sauce.',
      'price': 140,
      'image': 'assets/food/spicy_momo.png',
    },
    {
      'name': 'Iced Lemon Tea',
      'desc': 'Refreshing beverage to cool you down.',
      'price': 60,
      'image': 'assets/food/lemon_tea.png',
    },
  ];

  int cartCount = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/cart');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile');
    }
  }

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    // Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, User!',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '123 Main St',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Contact Button
                        IconButton(
                          icon: const Icon(
                            Icons.contact_support,
                            color: Colors.white,
                          ),
                          tooltip: 'Contact & Location',
                          onPressed: () {
                            Navigator.pushNamed(context, '/contact');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withOpacity(0.10),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search for momos, drinks, or combos…',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Roboto',
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white70,
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
                      height: 44,
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
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFFF44336),
                            backgroundColor:
                                isSelected
                                    ? const Color(0xFFF44336)
                                    : Colors.white.withOpacity(0.18),
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
                    const SizedBox(height: 24),
                    // Food Menu Section
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: foodItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final item = foodItems[idx];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const MenuItemDetailsScreen(),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFE79734),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      item['image'],
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 72,
                                                height: 72,
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.fastfood,
                                                  color: Colors.grey,
                                                  size: 32,
                                                ),
                                              ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['desc'],
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.black54,
                                                fontFamily: 'Roboto',
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '₹${item['price']}',
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color: const Color(0xFFF44336),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFF44336,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                        elevation: 2,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          cartCount++;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4f2f11),
        selectedItemColor: const Color(0xFFF44336),
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedTab,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.yellow,
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
