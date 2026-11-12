import 'package:flutter/material.dart';
import '../models/attendance_record.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';

/// Clean activity tile rendering a single attendance action entry
class ActivityTile extends StatelessWidget {
  final AttendanceRecord record;

  const ActivityTile({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBg, statusText) = _getStatusProps(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          // Initials Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryContainer,
            child: Text(
              _getInitials(record.studentName),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.rollNumber} • ${record.className}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Time & Status Chip
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                record.timeFormatted,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return 'ST';
  }

  (Color, Color, String) _getStatusProps(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return (AppTheme.success, AppTheme.successContainer, 'Present');
      case AttendanceStatus.absent:
        return (AppTheme.danger, AppTheme.dangerContainer, 'Absent');
      case AttendanceStatus.late:
        return (AppTheme.warning, AppTheme.warningContainer, 'Late');
      case AttendanceStatus.unmarked:
        return (AppTheme.textMuted, AppTheme.background, 'Unmarked');
    }
  }
}
