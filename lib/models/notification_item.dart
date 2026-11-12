import 'package:flutter/material.dart';

enum NotificationType {
  info,
  success,
  warning,
  alert,
}

/// Represents an in-app alert or notification for the faculty
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline_rounded;
      case NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.alert:
        return Icons.error_outline_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.info:
        return const Color(0xFF3B82F6);
      case NotificationType.success:
        return const Color(0xFF10B981);
      case NotificationType.warning:
        return const Color(0xFFF59E0B);
      case NotificationType.alert:
        return const Color(0xFFEF4444);
    }
  }
}
