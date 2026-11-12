import 'package:flutter/material.dart';
import 'state/attendance_state.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AttendifyApp());
}

/// Root widget of the Attendify Application
class AttendifyApp extends StatefulWidget {
  const AttendifyApp({super.key});

  @override
  State<AttendifyApp> createState() => _AttendifyAppState();
}

class _AttendifyAppState extends State<AttendifyApp> {
  // In-memory reactive attendance state
  late final AttendanceState _attendanceState;

  @override
  void initState() {
    super.initState();
    _attendanceState = AttendanceState();
  }

  @override
  void dispose() {
    _attendanceState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AttendanceScope(
      state: _attendanceState,
      child: MaterialApp(
        title: 'Attendify - Student Attendance Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationShell(),
      ),
    );
  }
}
