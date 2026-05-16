import 'package:enzer_app/core/enums/notifications.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type = NotificationType.referral,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
      type: map['type'] == 'referral'
          ? NotificationType.referral
          : NotificationType.referral,
    );
  }
}
