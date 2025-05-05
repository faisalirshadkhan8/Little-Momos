// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactLocationScreen extends StatefulWidget {
  const ContactLocationScreen({super.key});

  @override
  State<ContactLocationScreen> createState() => _ContactLocationScreenState();
}

class _ContactLocationScreenState extends State<ContactLocationScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool isSubmitting = false;

  final String storeAddress =
      '241 C Jamia masjid road, C, near WT fries, opposite Government Millat high school, Satellite Town, Gujranwala, 52250';
  final String storeHours = 'Open today: 10:00 AM - 10:00 PM';
  final String phoneNumber = '+91 98765 43210';
  final String email = 'support@littlemomo.com';
  final String mapsUrl =
      'https://www.google.com/maps/search/?api=1&query=241+C+Jamia+masjid+road,+C,+near+WT+fries,+opposite+Government+Millat+high+school,+Satellite+Town,+Gujranwala,+52250';
  final String website = 'https://littlemomo.com';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact & Location',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4f2f11),
        foregroundColor: Colors.white,
        elevation: 0,
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Top Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Us',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We're here to help! Reach out to us for support",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Location Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFFF44336),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              storeAddress,
                              style: const TextStyle(fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: Colors.grey[300],
                          width: double.infinity,
                          height: 160,
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.map,
                                  size: 80,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF44336),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final testUri = Uri.parse(
                                      'https://flutter.dev',
                                    );
                                    if (await canLaunchUrl(testUri)) {
                                      await launchUrl(testUri);
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Could not open browser.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.directions),
                                  label: const Text('Get Directions'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFFF44336),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            storeHours,
                            style: const TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Contact Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Options',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: Color(0xFFF44336),
                          size: 32,
                        ),
                        title: Text(
                          phoneNumber,
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: Color(0xFFF44336),
                          ),
                          iconSize: 32,
                          onPressed: () async {
                            final uri = Uri(scheme: 'tel', path: phoneNumber);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          splashRadius: 28,
                        ),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 48,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Color(0xFFF44336),
                          size: 32,
                        ),
                        title: Text(
                          email,
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFFF44336),
                          ),
                          iconSize: 32,
                          onPressed: () async {
                            final uri = Uri(scheme: 'mailto', path: email);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          splashRadius: 28,
                        ),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 48,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.language,
                          color: Color(0xFFF44336),
                          size: 32,
                        ),
                        title: Text(
                          website,
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.open_in_new,
                            color: Color(0xFFF44336),
                          ),
                          iconSize: 32,
                          onPressed: () async {
                            if (await canLaunchUrl(Uri.parse(website))) {
                              await launchUrl(Uri.parse(website));
                            }
                          },
                          splashRadius: 28,
                        ),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 48,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Feedback / Support Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback / Support',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _feedbackController,
                        minLines: 2,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText:
                              'Let us know how we can help you... (e.g., Less spicy, delivery issue)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
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
                          onPressed:
                              isSubmitting
                                  ? null
                                  : () async {
                                    setState(() => isSubmitting = true);
                                    await Future.delayed(
                                      const Duration(seconds: 2),
                                    );
                                    setState(() => isSubmitting = false);
                                    _feedbackController.clear();
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Feedback submitted!'),
                                      ),
                                    );
                                  },
                          child:
                              isSubmitting
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : const Text('Submit'),
                        ),
                      ),
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
