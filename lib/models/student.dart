import 'package:flutter/material.dart';

/// Attendance status for a student on any given session/day
enum AttendanceStatus {
  present,
  absent,
  late,
  unmarked,
}

/// Student model holding profile, class, and attendance data
class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String className;
  final String department;
  final String email;
  final String phone;
  final double overallAttendance; // Percentage (e.g. 88.5)
  AttendanceStatus status;
  final Color avatarColor;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    required this.department,
    required this.email,
    required this.phone,
    required this.overallAttendance,
    this.status = AttendanceStatus.present,
    required this.avatarColor,
  });

  /// Short initials for avatar representation
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length > 1 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'ST';
  }

  /// Human-friendly status label
  String get statusLabel {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.unmarked:
        return 'Unmarked';
    }
  }

  /// Create a clone with updated status
  Student copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? className,
    String? department,
    String? email,
    String? phone,
    double? overallAttendance,
    AttendanceStatus? status,
    Color? avatarColor,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      department: department ?? this.department,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      overallAttendance: overallAttendance ?? this.overallAttendance,
      status: status ?? this.status,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}
