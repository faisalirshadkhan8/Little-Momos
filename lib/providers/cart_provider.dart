// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get items => _items;

  // Updated to return total quantity instead of just item count
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  // Original item count (unique items)
  int get uniqueItemCount => _items.length;

  double get totalAmount {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item['totalPrice'] as double),
    );
  }

  // Constructor to load cart data on initialization
  CartProvider() {
    loadCartFromFirestore();
  }

  // Get current user ID or return null if not logged in
  String? get _userId => _auth.currentUser?.uid;

  // Load cart data from Firestore
  Future<void> loadCartFromFirestore() async {
    // Return if not logged in
    if (_userId == null) {
      debugPrint('Cannot load cart: User not logged in');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userDoc = await _firestore.collection('users').doc(_userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data()!;

        // Check if there's a cart field in the user document
        if (userData.containsKey('cart') && userData['cart'] != null) {
          _items.clear();
          final List<dynamic> itemsList = userData['cart'];
          for (var item in itemsList) {
            _items.add(Map<String, dynamic>.from(item));
          }
          debugPrint('Cart loaded from Firestore: ${_items.length} items');
        } else {
          debugPrint('No cart data found for current user');
        }
      } else {
        debugPrint('User document does not exist yet');
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save cart data to Firestore
  Future<void> saveCartToFirestore() async {
    // Return if not logged in
    if (_userId == null) {
      debugPrint('Cannot save cart: User not logged in');
      return;
    }

    try {
      // Store cart as a field in the user document rather than a subcollection
      await _firestore.collection('users').doc(_userId).set(
        {'cart': _items, 'cartUpdatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      ); // Using merge to avoid overwriting other user data

      debugPrint('Cart saved to Firestore: ${_items.length} items');
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addToCart(Map<String, dynamic> item) {
    // Check if the item already exists with the same customizations
    final existingIndex = _items.indexWhere(
      (element) =>
          element['id'] == item['id'] &&
          element['spiceLevel'] == item['spiceLevel'] &&
          element['extraCheese'] == item['extraCheese'],
    );

    if (existingIndex >= 0) {
      // Update existing item
      final existingItem = _items[existingIndex];
      final newQuantity =
          (existingItem['quantity'] as int) + (item['quantity'] as int);
      final newTotalPrice =
          ((item['price'] as num).toDouble() * newQuantity) +
          ((item['extraCheese'] as bool) ? 20.0 * newQuantity : 0.0);

      _items[existingIndex] = {
        ...existingItem,
        'quantity': newQuantity,
        'totalPrice': newTotalPrice,
      };
    } else {
      // Add new item
      _items.add(item);
    }

    notifyListeners();
    saveCartToFirestore(); // Save to Firestore after updating
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
    saveCartToFirestore(); // Save to Firestore after updating
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      final newTotalPrice =
          (item['price'] as num).toDouble() * quantity +
          ((item['extraCheese'] as bool) ? 20.0 * quantity : 0.0);

      _items[index] = {
        ...item,
        'quantity': quantity,
        'totalPrice': newTotalPrice,
      };

      notifyListeners();
      saveCartToFirestore(); // Save to Firestore after updating
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    saveCartToFirestore(); // Save to Firestore after updating
  }
}
