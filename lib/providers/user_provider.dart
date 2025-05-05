import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? name;
  String? email;
  String? address;
  String? phone;

  bool get isLoggedIn => name != null && email != null;

  void updateUser({
    required String name,
    required String email,
    required String address,
    required String phone,
  }) {
    this.name = name;
    this.email = email;
    this.address = address;
    this.phone = phone;
    notifyListeners();
  }

  void logout() {
    name = null;
    email = null;
    address = null;
    phone = null;
    notifyListeners();
  }
}
