import 'student.dart';

/// Represents a historical attendance mark action/log entry
class AttendanceRecord {
  final String id;
  final String studentName;
  final String rollNumber;
  final String className;
  final AttendanceStatus status;
  final String timeFormatted;
  final DateTime timestamp;

  AttendanceRecord({
    required this.id,
    required this.studentName,
    required this.rollNumber,
    required this.className,
    required this.status,
    required this.timeFormatted,
    required this.timestamp,
  });
}
