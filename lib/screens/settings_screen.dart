import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkMode = false;
  String language = 'English';
  bool rememberLogin = true;
  bool saveLastAddress = true;
  bool useGPS = false;
  final List<String> languages = ['English', 'Urdu', 'Punjabi', 'Other'];

  @override
  Widget build(BuildContext context) {
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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customize your experience',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Roboto',
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Preferences
                      Card(
                        elevation: 3,
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
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.notifications_active,
                                        color: Color(0xFFF44336),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Enable Notifications',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.dark_mode,
                                        color: Color(0xFFF44336),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Enable Dark Mode',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: darkMode,
                                    onChanged:
                                        (val) => setState(() => darkMode = val),
                                    activeColor: const Color(0xFFF44336),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: Color(0xFFF44336),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: language,
                                      decoration: const InputDecoration(
                                        labelText: 'Select Language',
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
                                            () => language = val ?? 'English',
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Account & Privacy
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Color(0xFFF44336),
                              ),
                              title: const Text(
                                'Edit Profile',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap:
                                  () =>
                                      Navigator.pushNamed(context, '/profile'),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFFF44336),
                              ),
                              title: const Text(
                                'Change Password',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {}, // TODO: Implement change password
                            ),
                            const Divider(height: 1),
                            SwitchListTile(
                              secondary: const Icon(
                                Icons.login,
                                color: Color(0xFFF44336),
                              ),
                              title: const Text(
                                'Remember Login Info',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                              value: rememberLogin,
                              onChanged:
                                  (val) => setState(() => rememberLogin = val),
                              activeColor: const Color(0xFFF44336),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: const Icon(
                                    Icons.cleaning_services,
                                    color: Color(0xFFF44336),
                                  ),
                                  label: const Text(
                                    'Clear App Cache',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xFFF44336),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFF44336),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cache cleared!'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Delivery Preferences
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.save,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Save Last Used Address',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Switch(
                                  value: saveLastAddress,
                                  onChanged:
                                      (val) =>
                                          setState(() => saveLastAddress = val),
                                  activeColor: const Color(0xFFF44336),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.gps_fixed,
                                  color: Color(0xFFF44336),
                                ),
                                title: const Text(
                                  'Use GPS to auto-detect location',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Switch(
                                  value: useGPS,
                                  onChanged:
                                      (val) => setState(() => useGPS = val),
                                  activeColor: const Color(0xFFF44336),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Legal & About
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.article,
                                color: Color(0xFFF44336),
                              ),
                              title: const Text(
                                'Terms & Conditions',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                              trailing: const Icon(Icons.chevron_right),
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
                              trailing: const Icon(Icons.chevron_right),
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
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
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
                          label: const Text('Log Out'),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
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
