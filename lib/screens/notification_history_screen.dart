import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_status_provider.dart';
import '../models/order_notification.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<OrderStatusProvider>().notifications;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body:
          notifications.isEmpty
              ? const Center(child: Text('No notifications yet.'))
              : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final OrderNotification n = notifications[index];
                  return ListTile(
                    title: Text(n.title),
                    subtitle: Text(n.message),
                    trailing: Text(
                      _formatDate(n.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/view_order_details',
                        arguments: {'orderId': n.orderId},
                      );
                    },
                  );
                },
              ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}\n${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
