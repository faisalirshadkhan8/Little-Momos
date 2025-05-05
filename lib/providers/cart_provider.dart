import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;
  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.name == item.name);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    final index = _items.indexWhere((i) => i.name == item.name);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
