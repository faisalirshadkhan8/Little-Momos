import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _menuService = MenuService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<String> _categories = [];
  List<String> get categories => _categories;

  // Get all menu items stream
  Stream<List<Map<String, dynamic>>> getMenuItemsStream() {
    return _menuService.getMenuItems();
  }

  // Get items by category - this was missing
  Stream<List<Map<String, dynamic>>> getMenuItemsByCategoryStream(
    String category,
  ) {
    return _menuService.getMenuItemsByCategory(category);
  }

  // Load available categories
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('menu').get();
      final Set<String> uniqueCategories = {};

      for (var doc in snapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          uniqueCategories.add(category);
        }
      }

      _categories = uniqueCategories.toList()..sort();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
