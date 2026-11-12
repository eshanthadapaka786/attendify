import 'package:flutter/material.dart';
import '../state/attendance_state.dart';
import '../theme/app_theme.dart';
import '../models/student.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/activity_tile.dart';
import '../widgets/student_card.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/notifications_sheet.dart';
import '../widgets/responsive_container.dart';

/// Primary Dashboard / Landing Page for Attendify
/// Implements all 10 required architectural sections with rich Material 3 polish.
class DashboardScreen extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const DashboardScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Format date helper: "Thursday, Nov 12, 2026"
  String _formatDate(DateTime dt) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final dayName = days[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    return '$dayName, $monthName ${dt.day}, ${dt.year}';
  }

  Future<void> _pickDate(BuildContext context, AttendanceState state) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      state.setSelectedDate(picked);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing attendance for ${_formatDate(picked)}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showManageClassesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final state = AttendanceScope.of(context);
        final classes = [
          {
            'name': 'CSE-3A',
            'room': 'Lab 402 - Turing Block',
            'count': '24 Students',
            'subject': 'Data Structures & Algorithms',
            'rate': '94.2%',
          },
          {
            'name': 'CSE-3B',
            'room': 'Lab 405 - Lovelace Block',
            'count': '24 Students',
            'subject': 'Object Oriented Programming',
            'rate': '88.5%',
          },
          {
            'name': 'ECE-2A',
            'room': 'Hall 201 - Shannon Block',
            'count': '18 Students',
            'subject': 'Digital Signal Processing',
            'rate': '91.0%',
          },
          {
            'name': 'IT-4A',
            'room': 'Room 108 - Hopper Block',
            'count': '16 Students',
            'subject': 'Cloud Computing & DevOps',
            'rate': '86.4%',
          },
        ];

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Classes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Assigned batches for Fall Semester',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...classes.map((c) {
                final isSelected = state.selectedClass == c['name'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryContainer : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                      width: isSelected ? 1.6 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          color: isSelected ? Colors.white : AppTheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c['name']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c['rate']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.successText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${c['subject']} • ${c['room']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          state.setSelectedClass(c['name']!);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Filtered to ${c['name']}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(isSelected ? 'Active' : 'Select'),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    state.setSelectedClass('All Classes');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear_all_rounded, size: 18),
                  label: const Text('Show All Classes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStudentDetails(BuildContext context, Student student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: student.avatarColor.withOpacity(0.15),
                    child: Text(
                      student.initials,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: student.avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${student.rollNumber} • ${student.className} • ${student.department}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppTheme.cardBorder, height: 1),
              const SizedBox(height: 16),

              // Overall Attendance stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(
                      label: 'Overall Rate',
                      val: '${student.overallAttendance}%',
                      color: student.overallAttendance >= 75
                          ? AppTheme.success
                          : AppTheme.danger,
                    ),
                    _buildStatCol(
                      label: 'Status Today',
                      val: student.statusLabel,
                      color: student.status == AttendanceStatus.present
                          ? AppTheme.success
                          : AppTheme.danger,
                    ),
                    _buildStatCol(
                      label: 'Classes Attended',
                      val: '42 / 46',
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contact Info
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email_outlined, color: AppTheme.primary),
                title: const Text('Email Address', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                subtitle: Text(student.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone_outlined, color: AppTheme.primary),
                title: const Text('Phone Number', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                subtitle: Text(student.phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              ),
              const SizedBox(height: 20),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNavigateTab?.call(2); // Jump to Mark Attendance
                  },
                  icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                  label: const Text('Update Attendance Status'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCol({
    required String label,
    required String val,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AttendanceScope.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isTablet = MediaQuery.of(context).size.width >= 600 && !isDesktop;

    return Scaffold(
      backgroundColor: AppTheme.background,

      // =======================================================================
      // 1. APP BAR with Attendify logo, notification icon and teacher profile
      // =======================================================================
      appBar: AppBar(
        titleSpacing: 16,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradientPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.how_to_reg_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            const Text(
              'ATTENDIFY',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'v1.0 LAB',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Notification Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                tooltip: 'Notifications',
                onPressed: () => NotificationsSheet.show(context),
              ),
              if (state.unreadNotificationsCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${state.unreadNotificationsCount}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Teacher Profile Avatar
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: InkWell(
              onTap: () {
                widget.onNavigateTab?.call(4); // Switch to Profile Screen
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 17,
                  backgroundColor: AppTheme.secondaryContainer,
                  child: Text(
                    'SJ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: state.refreshData,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================================
                // 2. WELCOME SECTION: Hello, Teacher! and current date
                // =============================================================
                _buildWelcomeHeader(context, state),
                const SizedBox(height: 18),

                // =============================================================
                // 3. HERO CARD: 'Smart Attendance, Smarter Learning'
                // =============================================================
                _buildHeroCard(context, state),
                const SizedBox(height: 22),

                // =============================================================
                // 4. FOUR STATISTICS CARDS
                // Total Students, Present Today, Absent Today, Attendance %
                // =============================================================
                _buildStatCardsSection(context, state, isDesktop, isTablet),
                const SizedBox(height: 24),

                // =============================================================
                // 5. ATTENDANCE OVERVIEW with attractive weekly chart
                // =============================================================
                const WeeklyChart(),
                const SizedBox(height: 24),

                // =============================================================
                // 6. QUICK ACTION CARDS
                // Add Student, Mark Attendance, View Reports, Manage Classes
                // =============================================================
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // =============================================================
                // 9. MONTHLY ATTENDANCE PROGRESS SECTION
                // =============================================================
                _buildMonthlyProgressSection(state),
                const SizedBox(height: 24),

                // =============================================================
                // 7. RECENT ATTENDANCE ACTIVITY
                // =============================================================
                _buildRecentActivitySection(context, state),
                const SizedBox(height: 24),

                // =============================================================
                // 8. STUDENT LIST PREVIEW with profile avatars and search
                // =============================================================
                _buildStudentListPreview(context, state),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 2. WELCOME HEADER ---
  Widget _buildWelcomeHeader(BuildContext context, AttendanceState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Hello, Teacher! 👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (state.selectedClass != 'All Classes')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.selectedClass,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back to your classroom attendance portal',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Interactive Date Selector Button
        InkWell(
          onTap: () => _pickDate(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(state.selectedDate),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. HERO CARD ---
  Widget _buildHeroCard(BuildContext context, AttendanceState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative shapes in the background
          Positioned(
            right: -20,
            bottom: -20,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            right: 80,
            top: -30,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 14, color: Colors.amberAccent),
                      SizedBox(width: 4),
                      Text(
                        'Fast & Contactless Roll-Call',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Main Heading
                const Text(
                  'Smart Attendance,\nSmarter Learning',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.6,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Seamlessly track ${state.totalStudents} students across 4 lecture batches with automated analytics and real-time defaulter alerts.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.88),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),

                // Mark Attendance CTA Button
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.onNavigateTab?.call(2); // Jump to Mark Attendance Tab
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_rounded, size: 20),
                      label: const Text(
                        'Mark Attendance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => AddStudentDialog.show(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                      label: const Text(
                        'Add Student',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. FOUR STATISTICS CARDS ---
  Widget _buildStatCardsSection(
    BuildContext context,
    AttendanceState state,
    bool isDesktop,
    bool isTablet,
  ) {
    final cards = [
      StatCard(
        title: 'Total Students',
        value: '${state.totalStudents}',
        subtitle: '${SampleData.availableClasses.length - 1} Active Batches',
        icon: Icons.groups_rounded,
        accentColor: AppTheme.primary,
        backgroundColor: AppTheme.primaryContainer,
        onTap: () => widget.onNavigateTab?.call(1), // Students tab
      ),
      StatCard(
        title: 'Present Today',
        value: '${state.presentCount}',
        subtitle: '${state.lateCount} students arrived late',
        icon: Icons.check_circle_outline_rounded,
        accentColor: AppTheme.success,
        backgroundColor: AppTheme.successContainer,
        onTap: () => widget.onNavigateTab?.call(2), // Attendance tab
      ),
      StatCard(
        title: 'Absent Today',
        value: '${state.absentCount}',
        subtitle: '${state.lowAttendanceStudents.length} low attendance alerts',
        icon: Icons.cancel_outlined,
        accentColor: AppTheme.danger,
        backgroundColor: AppTheme.dangerContainer,
        onTap: () => widget.onNavigateTab?.call(2),
      ),
      StatCard(
        title: 'Attendance Rate',
        value: '${state.attendancePercentage.toStringAsFixed(1)}%',
        subtitle: 'Target requirement: 75%',
        icon: Icons.pie_chart_outline_rounded,
        accentColor: AppTheme.secondary,
        backgroundColor: AppTheme.secondaryContainer,
        progress: state.attendancePercentage / 100.0,
        onTap: () => widget.onNavigateTab?.call(3), // Reports tab
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards
            .map((card) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: card,
                  ),
                ))
            .toList(),
      );
    }

    // Grid for tablet or mobile 2x2
    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isTablet ? 1.05 : 0.95,
      children: cards,
    );
  }

  // --- 6. QUICK ACTION CARDS ---
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            return GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isWide ? 1.4 : 1.5,
              children: [
                _buildActionCard(
                  title: 'Mark Attendance',
                  subtitle: 'Take roll call now',
                  icon: Icons.checklist_rounded,
                  color: AppTheme.primary,
                  onTap: () => widget.onNavigateTab?.call(2),
                ),
                _buildActionCard(
                  title: 'Add Student',
                  subtitle: 'Enroll in class',
                  icon: Icons.person_add_rounded,
                  color: AppTheme.secondary,
                  onTap: () => AddStudentDialog.show(context),
                ),
                _buildActionCard(
                  title: 'View Reports',
                  subtitle: 'Analytics & graphs',
                  icon: Icons.bar_chart_rounded,
                  color: AppTheme.info,
                  onTap: () => widget.onNavigateTab?.call(3),
                ),
                _buildActionCard(
                  title: 'Manage Classes',
                  subtitle: 'Batches & schedules',
                  icon: Icons.class_outlined,
                  color: AppTheme.warning,
                  onTap: () => _showManageClassesSheet(context),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 9. MONTHLY ATTENDANCE PROGRESS SECTION ---
  Widget _buildMonthlyProgressSection(AttendanceState state) {
    const monthlyAverage = 91.4;
    const target = 85.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Attendance Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'November 2026 Academic Cycle',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+6.4% Above Target',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.successText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Visual Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Achievement: 91.4%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              Text(
                'Department Target: ${target.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: Stack(
                children: [
                  Container(color: AppTheme.background),
                  FractionallySizedBox(
                    widthFactor: monthlyAverage / 100.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppTheme.cardGradientPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Three highlight pills
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  label: 'Working Days',
                  value: '22 Days',
                  icon: Icons.date_range_rounded,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricItem(
                  label: 'Best Record',
                  value: 'Thursday (96%)',
                  icon: Icons.thumb_up_alt_outlined,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricItem(
                  label: 'At Risk (<75%)',
                  value: '${state.lowAttendanceStudents.length} Students',
                  icon: Icons.warning_amber_rounded,
                  color: AppTheme.danger,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 7. RECENT ATTENDANCE ACTIVITY ---
  Widget _buildRecentActivitySection(
    BuildContext context,
    AttendanceState state,
  ) {
    final activities = state.activities.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Attendance Activity',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => widget.onNavigateTab?.call(2), // Attendance screen
              child: const Text('View All Activity'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (activities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: const Center(
              child: Text(
                'No attendance activity recorded yet.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          )
        else
          ...activities.map((record) => ActivityTile(record: record)),
      ],
    );
  }

  // --- 8. STUDENT LIST PREVIEW with live search and quick toggle ---
  Widget _buildStudentListPreview(
    BuildContext context,
    AttendanceState state,
  ) {
    final filtered = state.filteredStudents;
    final previewList = filtered.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Roster Preview',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Quick toggle status with P (Present) or A (Absent)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => widget.onNavigateTab?.call(1), // Students tab
              child: const Text('View Full Roster'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Live Search Bar
        TextField(
          controller: _searchController,
          onChanged: (val) {
            state.setSearchQuery(val);
          },
          decoration: InputDecoration(
            hintText: 'Search by student name, roll number, or class...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      state.clearSearch();
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 14),

        // Preview Student Cards
        if (previewList.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No students match "${state.searchQuery}"',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      state.clearSearch();
                    },
                    child: const Text('Clear search'),
                  ),
                ],
              ),
            ),
          )
        else
          ...previewList.map(
            (student) => StudentCard(
              student: student,
              onTap: () => _showStudentDetails(context, student),
              onStatusChanged: (newStatus) {
                state.setStudentStatus(student.id, newStatus);
              },
            ),
          ),

        if (filtered.length > 6)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton.icon(
                onPressed: () => widget.onNavigateTab?.call(1),
                icon: const Icon(Icons.groups_outlined, size: 18),
                label: Text('View all ${filtered.length} students'),
              ),
            ),
          ),
      ],
    );
  }
}
