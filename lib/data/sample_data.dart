import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/attendance_record.dart';
import '../models/notification_item.dart';

/// Pre-populated realistic sample data for the Attendify demonstration
class SampleData {
  static const List<Color> avatarColors = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF7C3AED), // Purple
    Color(0xFF059669), // Emerald
    Color(0xFF0284C7), // Sky Blue
    Color(0xFFD97706), // Amber
    Color(0xFFE11D48), // Rose
    Color(0xFF7C2D12), // Rust
    Color(0xFF0D9488), // Teal
  ];

  /// Initial roster of realistic college students
  static List<Student> getInitialStudents() {
    return [
      Student(
        id: 'std_01',
        name: 'Aarav Sharma',
        rollNumber: '24CS001',
        className: 'CSE-3A',
        department: 'Computer Science',
        email: 'aarav.sharma@campusone.edu',
        phone: '+91 98765 43210',
        overallAttendance: 94.5,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[0],
      ),
      Student(
        id: 'std_02',
        name: 'Emily Watson',
        rollNumber: '24CS002',
        className: 'CSE-3A',
        department: 'Computer Science',
        email: 'emily.watson@campusone.edu',
        phone: '+1 555-0192',
        overallAttendance: 91.0,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[1],
      ),
      Student(
        id: 'std_03',
        name: 'Rahul Verma',
        rollNumber: '24CS003',
        className: 'CSE-3A',
        department: 'Computer Science',
        email: 'rahul.verma@campusone.edu',
        phone: '+91 91234 56789',
        overallAttendance: 68.2, // Below 75% alert
        status: AttendanceStatus.absent,
        avatarColor: avatarColors[2],
      ),
      Student(
        id: 'std_04',
        name: 'Sophia Miller',
        rollNumber: '24CS004',
        className: 'CSE-3A',
        department: 'Computer Science',
        email: 'sophia.m@campusone.edu',
        phone: '+1 555-0144',
        overallAttendance: 96.0,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[3],
      ),
      Student(
        id: 'std_05',
        name: 'Michael Chang',
        rollNumber: '24CS005',
        className: 'CSE-3B',
        department: 'Computer Science',
        email: 'michael.c@campusone.edu',
        phone: '+1 555-0188',
        overallAttendance: 88.5,
        status: AttendanceStatus.late,
        avatarColor: avatarColors[4],
      ),
      Student(
        id: 'std_06',
        name: 'Priya Patel',
        rollNumber: '24CS006',
        className: 'CSE-3B',
        department: 'Computer Science',
        email: 'priya.patel@campusone.edu',
        phone: '+91 97890 12345',
        overallAttendance: 71.5, // Below 75% alert
        status: AttendanceStatus.absent,
        avatarColor: avatarColors[5],
      ),
      Student(
        id: 'std_07',
        name: 'Ethan Wright',
        rollNumber: '24CS007',
        className: 'CSE-3B',
        department: 'Computer Science',
        email: 'ethan.w@campusone.edu',
        phone: '+1 555-0129',
        overallAttendance: 92.0,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[6],
      ),
      Student(
        id: 'std_08',
        name: 'Ananya Iyer',
        rollNumber: '24CS008',
        className: 'ECE-2A',
        department: 'Electronics',
        email: 'ananya.iyer@campusone.edu',
        phone: '+91 99887 76655',
        overallAttendance: 97.4,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[7],
      ),
      Student(
        id: 'std_09',
        name: 'Lucas Garcia',
        rollNumber: '24CS009',
        className: 'ECE-2A',
        department: 'Electronics',
        email: 'lucas.g@campusone.edu',
        phone: '+1 555-0177',
        overallAttendance: 84.0,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[0],
      ),
      Student(
        id: 'std_10',
        name: 'Olivia Brown',
        rollNumber: '24CS010',
        className: 'ECE-2A',
        department: 'Electronics',
        email: 'olivia.b@campusone.edu',
        phone: '+1 555-0163',
        overallAttendance: 89.2,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[1],
      ),
      Student(
        id: 'std_11',
        name: 'David Kim',
        rollNumber: '24CS011',
        className: 'IT-4A',
        department: 'Information Tech',
        email: 'david.kim@campusone.edu',
        phone: '+1 555-0131',
        overallAttendance: 93.8,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[2],
      ),
      Student(
        id: 'std_12',
        name: 'Jessica Taylor',
        rollNumber: '24CS012',
        className: 'IT-4A',
        department: 'Information Tech',
        email: 'jessica.t@campusone.edu',
        phone: '+1 555-0199',
        overallAttendance: 82.5,
        status: AttendanceStatus.present,
        avatarColor: avatarColors[3],
      ),
    ];
  }

  /// Initial live activity logs
  static List<AttendanceRecord> getInitialActivity() {
    final now = DateTime.now();
    return [
      AttendanceRecord(
        id: 'rec_01',
        studentName: 'Aarav Sharma',
        rollNumber: '24CS001',
        className: 'CSE-3A',
        status: AttendanceStatus.present,
        timeFormatted: '09:15 AM',
        timestamp: now.subtract(const Duration(minutes: 15)),
      ),
      AttendanceRecord(
        id: 'rec_02',
        studentName: 'Emily Watson',
        rollNumber: '24CS002',
        className: 'CSE-3A',
        status: AttendanceStatus.present,
        timeFormatted: '09:14 AM',
        timestamp: now.subtract(const Duration(minutes: 16)),
      ),
      AttendanceRecord(
        id: 'rec_03',
        studentName: 'Rahul Verma',
        rollNumber: '24CS003',
        className: 'CSE-3A',
        status: AttendanceStatus.absent,
        timeFormatted: '09:10 AM',
        timestamp: now.subtract(const Duration(minutes: 20)),
      ),
      AttendanceRecord(
        id: 'rec_04',
        studentName: 'Michael Chang',
        rollNumber: '24CS005',
        className: 'CSE-3B',
        status: AttendanceStatus.late,
        timeFormatted: '09:08 AM',
        timestamp: now.subtract(const Duration(minutes: 22)),
      ),
      AttendanceRecord(
        id: 'rec_05',
        studentName: 'Priya Patel',
        rollNumber: '24CS006',
        className: 'CSE-3B',
        status: AttendanceStatus.absent,
        timeFormatted: '09:05 AM',
        timestamp: now.subtract(const Duration(minutes: 25)),
      ),
      AttendanceRecord(
        id: 'rec_06',
        studentName: 'Ananya Iyer',
        rollNumber: '24CS008',
        className: 'ECE-2A',
        status: AttendanceStatus.present,
        timeFormatted: '09:02 AM',
        timestamp: now.subtract(const Duration(minutes: 28)),
      ),
    ];
  }

  /// Realistic sample notifications
  static List<AppNotification> getInitialNotifications() {
    return [
      AppNotification(
        id: 'notif_1',
        title: 'Defaulter Alert (Below 75%)',
        message: 'Rahul Verma & Priya Patel are below the required 75% attendance threshold.',
        timeAgo: '10m ago',
        type: NotificationType.alert,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Morning Session Recorded',
        message: 'CSE-3A Attendance has been successfully logged for today.',
        timeAgo: '25m ago',
        type: NotificationType.success,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Weekly Report Available',
        message: 'Weekly consolidated attendance analytics for week 45 is ready for review.',
        timeAgo: '2h ago',
        type: NotificationType.info,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_4',
        title: 'Academic Notice',
        message: 'Mid-term attendance freeze date is scheduled for November 25, 2026.',
        timeAgo: '1d ago',
        type: NotificationType.warning,
        isRead: true,
      ),
    ];
  }

  /// Weekly attendance trend metrics for custom chart
  static const List<Map<String, dynamic>> weeklyChartData = [
    {'day': 'Mon', 'percent': 92, 'present': 44, 'absent': 4},
    {'day': 'Tue', 'percent': 88, 'present': 42, 'absent': 6},
    {'day': 'Wed', 'percent': 83, 'present': 40, 'absent': 8},
    {'day': 'Thu', 'percent': 96, 'present': 46, 'absent': 2},
    {'day': 'Fri', 'percent': 90, 'present': 43, 'absent': 5},
    {'day': 'Sat', 'percent': 94, 'present': 45, 'absent': 3},
  ];

  /// List of available class filters
  static const List<String> availableClasses = [
    'All Classes',
    'CSE-3A',
    'CSE-3B',
    'ECE-2A',
    'IT-4A',
  ];
}
