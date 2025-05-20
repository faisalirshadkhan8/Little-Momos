import 'package:cloud_firestore/cloud_firestore.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of all menu items
  Stream<List<Map<String, dynamic>>> getMenuItems() {
    return _firestore
        .collection('menuItems')
        .where('status', isEqualTo: 'Available') // Only get available items
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  // Get menu items by category
  Stream<List<Map<String, dynamic>>> getMenuItemsByCategory(String category) {
    return _firestore
        .collection('menu')
        .where('category', isEqualTo: category)
        .where('status', isEqualTo: 'Available')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  // Get a single menu item by ID
  Future<Map<String, dynamic>> getMenuItemById(String id) async {
    final doc = await _firestore.collection('menu').doc(id).get();
    if (!doc.exists) {
      throw Exception('Menu item not found');
    }
    return {'id': doc.id, ...doc.data()!};
  }
}
