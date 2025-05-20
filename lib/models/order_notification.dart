class OrderNotification {
  final String orderId;
  final String title;
  final String message;
  final String status;
  final DateTime timestamp;

  OrderNotification({
    required this.orderId,
    required this.title,
    required this.message,
    required this.status,
    required this.timestamp,
  });

  factory OrderNotification.fromJson(Map<String, dynamic> json) {
    return OrderNotification(
      orderId: json['orderId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'title': title,
      'message': message,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
