import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/attendance_record.dart';
import '../models/notification_item.dart';
import '../data/sample_data.dart';

/// Central state management for Attendify using ChangeNotifier.
/// Fully reactive: any change to student attendance immediately updates
/// all metrics, stats cards, activity lists, and visual charts.
class AttendanceState extends ChangeNotifier {
  late List<Student> _students;
  late List<AttendanceRecord> _activities;
  late List<AppNotification> _notifications;

  DateTime _selectedDate = DateTime.now();
  String _selectedClass = 'All Classes';
  String _searchQuery = '';
  bool _isLoading = false;

  AttendanceState() {
    _students = SampleData.getInitialStudents();
    _activities = SampleData.getInitialActivity();
    _notifications = SampleData.getInitialNotifications();
  }

  // --- Getters ---
  List<Student> get students => List.unmodifiable(_students);
  List<AttendanceRecord> get activities => List.unmodifiable(_activities);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  DateTime get selectedDate => _selectedDate;
  String get selectedClass => _selectedClass;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  int get totalStudents => _students.length;

  int get presentCount =>
      _students.where((s) => s.status == AttendanceStatus.present).length;

  int get absentCount =>
      _students.where((s) => s.status == AttendanceStatus.absent).length;

  int get lateCount =>
      _students.where((s) => s.status == AttendanceStatus.late).length;

  int get unmarkedCount =>
      _students.where((s) => s.status == AttendanceStatus.unmarked).length;

  double get attendancePercentage {
    if (totalStudents == 0) return 0.0;
    return (presentCount / totalStudents) * 100.0;
  }

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  /// Returns students filtered by class and search query
  List<Student> get filteredStudents {
    return _students.where((student) {
      final matchesClass = _selectedClass == 'All Classes' ||
          student.className.toLowerCase() == _selectedClass.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.className.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesClass && matchesSearch;
    }).toList();
  }

  /// Students with low attendance (< 75%)
  List<Student> get lowAttendanceStudents {
    return _students.where((s) => s.overallAttendance < 75.0).toList();
  }

  // --- Actions ---

  /// Toggles attendance status for a student between Present, Absent, and Late
  void toggleStudentStatus(String studentId) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      final current = _students[index].status;
      final next = current == AttendanceStatus.present
          ? AttendanceStatus.absent
          : (current == AttendanceStatus.absent
              ? AttendanceStatus.late
              : AttendanceStatus.present);
      setStudentStatus(studentId, next);
    }
  }

  /// Sets specific attendance status for a student
  void setStudentStatus(String studentId, AttendanceStatus newStatus) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      _students[index].status = newStatus;

      // Add to recent activity stream
      final now = DateTime.now();
      final timeStr = _formatTime(now);

      _activities.insert(
        0,
        AttendanceRecord(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          studentName: _students[index].name,
          rollNumber: _students[index].rollNumber,
          className: _students[index].className,
          status: newStatus,
          timeFormatted: timeStr,
          timestamp: now,
        ),
      );

      // Keep recent activity bounded to 20 items
      if (_activities.length > 20) {
        _activities = _activities.sublist(0, 20);
      }

      notifyListeners();
    }
  }

  /// Bulk marks all students as Present
  void markAllPresent() {
    for (var student in _students) {
      student.status = AttendanceStatus.present;
    }
    _activities.insert(
      0,
      AttendanceRecord(
        id: 'bulk_${DateTime.now().millisecondsSinceEpoch}',
        studentName: 'All Students ($totalStudents)',
        rollNumber: 'BATCH',
        className: _selectedClass,
        status: AttendanceStatus.present,
        timeFormatted: _formatTime(DateTime.now()),
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// Bulk marks all students as Absent
  void markAllAbsent() {
    for (var student in _students) {
      student.status = AttendanceStatus.absent;
    }
    _activities.insert(
      0,
      AttendanceRecord(
        id: 'bulk_${DateTime.now().millisecondsSinceEpoch}',
        studentName: 'All Students ($totalStudents)',
        rollNumber: 'BATCH',
        className: _selectedClass,
        status: AttendanceStatus.absent,
        timeFormatted: _formatTime(DateTime.now()),
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// Adds a new student to the local in-memory dataset
  void addStudent({
    required String name,
    required String rollNumber,
    required String className,
    required String department,
    required String email,
    required String phone,
  }) {
    final color = SampleData.avatarColors[_students.length % SampleData.avatarColors.length];
    final newStudent = Student(
      id: 'std_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      rollNumber: rollNumber.trim().toUpperCase(),
      className: className.trim(),
      department: department.trim(),
      email: email.trim(),
      phone: phone.trim(),
      overallAttendance: 100.0,
      status: AttendanceStatus.present,
      avatarColor: color,
    );

    _students.insert(0, newStudent);

    // Add notification
    _notifications.insert(
      0,
      AppNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Student Enrolled',
        message: '$name ($rollNumber) was added to $className.',
        timeAgo: 'Just now',
        type: NotificationType.success,
        isRead: false,
      ),
    );

    // Add activity record
    _activities.insert(
      0,
      AttendanceRecord(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        studentName: name,
        rollNumber: rollNumber,
        className: className,
        status: AttendanceStatus.present,
        timeFormatted: _formatTime(DateTime.now()),
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  /// Deletes a student from the list
  void removeStudent(String studentId) {
    _students.removeWhere((s) => s.id == studentId);
    notifyListeners();
  }

  /// Updates selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Updates selected class filter
  void setSelectedClass(String className) {
    _selectedClass = className;
    notifyListeners();
  }

  /// Updates search query for live filtering
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clears active search
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Marks all unread notifications as read
  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  /// Simulates a brief pull-to-refresh
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _isLoading = false;
    notifyListeners();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}

/// InheritedNotifier for zero-boilerplate, reliable Flutter state access
class AttendanceScope extends InheritedNotifier<AttendanceState> {
  const AttendanceScope({
    super.key,
    required AttendanceState state,
    required super.child,
  }) : super(notifier: state);

  static AttendanceState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AttendanceScope>();
    assert(scope != null, 'No AttendanceScope found in context');
    return scope!.notifier!;
  }
}
