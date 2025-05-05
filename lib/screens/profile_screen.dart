// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool notificationsEnabled = true;
  bool darkMode = false;
  bool saveDeliveryPref = true;
  String preferredLanguage = 'English';
  final List<String> languages = ['English', 'Urdu', 'Punjabi', 'Other'];
  String? profileImagePath;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: user.name ?? '');
    _emailController = TextEditingController(text: user.email ?? '');
    _phoneController = TextEditingController(text: user.phone ?? '');
    _addressController = TextEditingController(text: user.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'address': _addressController.text.trim(),
                'phone': _phoneController.text.trim(),
              });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile in cloud: $e')),
        );
      }
      setState(() {
        isEditing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    }
  }

  void _pickProfileImage() async {
    // Placeholder for image picker logic
    // You can use image_picker package for real implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile photo upload coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top Section: Avatar, Name, Email, Edit
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 20,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: const Color(0xFFF44336),
                                    backgroundImage:
                                        profileImagePath != null
                                            ? AssetImage(profileImagePath!)
                                            : null,
                                    child:
                                        profileImagePath == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 48,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isEditing
                                          ? TextFormField(
                                            controller: _nameController,
                                            decoration: const InputDecoration(
                                              labelText: 'Full Name',
                                              prefixIcon: Icon(Icons.person),
                                            ),
                                            validator:
                                                (value) =>
                                                    value == null ||
                                                            value.isEmpty
                                                        ? 'Enter your name'
                                                        : null,
                                          )
                                          : Text(
                                            _nameController.text.isNotEmpty
                                                ? _nameController.text
                                                : 'Your Name',
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                          ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    if (isEditing) {
                                      _saveProfile();
                                    } else {
                                      setState(() {
                                        isEditing = true;
                                      });
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFF44336),
                                    side: const BorderSide(
                                      color: Color(0xFFF44336),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    isEditing ? 'Save' : 'Edit Profile',
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: Color(0xFFF44336),
                            ),
                            title: const Text(
                              'Settings',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap:
                                () => Navigator.pushNamed(context, '/settings'),
                          ),
                        ),
                        // Editable Account Info Section
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email
                                isEditing
                                    ? TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email Address',
                                        prefixIcon: Icon(Icons.email),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator:
                                          (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Enter your email'
                                                  : null,
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Colors.brown,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _emailController.text,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Text(
                                                  'Email Address',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                const SizedBox(height: 16),
                                // Phone
                                isEditing
                                    ? TextFormField(
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        prefixIcon: Icon(Icons.phone),
                                      ),
                                      keyboardType: TextInputType.phone,
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Colors.brown,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _phoneController.text,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Text(
                                                  'Phone Number',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                const SizedBox(height: 16),
                                // Address
                                isEditing
                                    ? TextFormField(
                                      controller: _addressController,
                                      decoration: const InputDecoration(
                                        labelText: 'Delivery Address',
                                        prefixIcon: Icon(Icons.home),
                                      ),
                                      minLines: 1,
                                      maxLines: 2,
                                      validator:
                                          (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Enter your address'
                                                  : null,
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.home,
                                            color: Colors.brown,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _addressController.text,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Text(
                                                  'Delivery Address',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isEditing)
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isEditing = true;
                                                });
                                              },
                                              child: const Text('Edit'),
                                            ),
                                        ],
                                      ),
                                    ),
                                const SizedBox(height: 16),
                                if (user.email != null &&
                                    user.email!.endsWith('@gmail.com'))
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.verified,
                                        color: Color(0xFFF44336),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Signed in with Google',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontFamily: 'Roboto',
                                              color: Colors.black54,
                                            ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Preferences Section
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'App Notifications',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Switch(
                                      value: notificationsEnabled,
                                      onChanged:
                                          (val) => setState(
                                            () => notificationsEnabled = val,
                                          ),
                                      activeColor: const Color(0xFFF44336),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Dark Mode',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Switch(
                                      value: darkMode,
                                      onChanged:
                                          (val) =>
                                              setState(() => darkMode = val),
                                      activeColor: const Color(0xFFF44336),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Save Delivery Preferences',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Switch(
                                      value: saveDeliveryPref,
                                      onChanged:
                                          (val) => setState(
                                            () => saveDeliveryPref = val,
                                          ),
                                      activeColor: const Color(0xFFF44336),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: preferredLanguage,
                                  decoration: const InputDecoration(
                                    labelText: 'Preferred Language',
                                    prefixIcon: Icon(Icons.language),
                                  ),
                                  items:
                                      languages
                                          .map(
                                            (lang) => DropdownMenuItem(
                                              value: lang,
                                              child: Text(
                                                lang,
                                                style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) => setState(
                                        () =>
                                            preferredLanguage =
                                                val ?? 'English',
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // App & Support Links
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.help_outline,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Help / FAQ',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(
                                  Icons.support_agent,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Contact Support',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'About Little Momo',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(
                                  Icons.privacy_tip,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                                onTap: () {},
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(
                                  Icons.article,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(fontFamily: 'Roboto'),
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              // Logout Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    onPressed: () {
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).logout();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
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
