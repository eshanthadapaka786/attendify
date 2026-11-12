import 'package:flutter/material.dart';
import '../state/attendance_state.dart';
import '../theme/app_theme.dart';
import '../models/student.dart';
import '../data/sample_data.dart';
import '../widgets/responsive_container.dart';

/// Interactive attendance marking interface with Present / Absent / Late toggles,
/// batch operations, live statistics counter, and confirmation submission.
class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _submitAttendance(BuildContext context, AttendanceState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.successContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppTheme.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Saved',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Session record finalized',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance records for ${_formatDate(state.selectedDate)} have been logged successfully into the academic ledger.',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryMini(
                      label: 'Present',
                      count: state.presentCount,
                      color: AppTheme.success,
                    ),
                    _buildSummaryMini(
                      label: 'Absent',
                      count: state.absentCount,
                      color: AppTheme.danger,
                    ),
                    _buildSummaryMini(
                      label: 'Late',
                      count: state.lateCount,
                      color: AppTheme.warning,
                    ),
                    _buildSummaryMini(
                      label: 'Rate',
                      count: state.attendancePercentage.round(),
                      suffix: '%',
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryMini({
    required String label,
    required int count,
    String suffix = '',
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          '$count$suffix',
          style: TextStyle(
            fontSize: 15,
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
    final students = state.filteredStudents;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            tooltip: 'Change Date',
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                state.setSelectedDate(picked);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sticky Top Section: Date + Class Filter + Counters + Batch buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: ResponsiveContainer(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(state.selectedDate),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${state.presentCount} / ${state.totalStudents} Present',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Class filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: SampleData.availableClasses.map((className) {
                        final isSelected = state.selectedClass == className;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(className),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) state.setSelectedClass(className);
                            },
                            backgroundColor: AppTheme.background,
                            selectedColor: AppTheme.primary,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.cardBorder,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Batch Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => state.markAllPresent(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.successText,
                            side: const BorderSide(color: AppTheme.success, width: 1.2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                          label: const Text('Mark All Present', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => state.markAllAbsent(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.dangerText,
                            side: const BorderSide(color: AppTheme.danger, width: 1.2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.highlight_off_rounded, size: 16),
                          label: const Text('Mark All Absent', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Live Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => state.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Filter students in ${state.selectedClass}...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
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
                ],
              ),
            ),
          ),
          const Divider(color: AppTheme.cardBorder, height: 1),

          // Scrollable Students List
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_search_rounded,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No students match the criteria',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            state.clearSearch();
                            state.setSelectedClass('All Classes');
                          },
                          child: const Text('Reset filters'),
                        ),
                      ],
                    ),
                  )
                : ResponsiveContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: students.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final isPresent = student.status == AttendanceStatus.present;
                        final isAbsent = student.status == AttendanceStatus.absent;
                        final isLate = student.status == AttendanceStatus.late;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isAbsent
                                  ? AppTheme.danger.withOpacity(0.3)
                                  : AppTheme.cardBorder,
                              width: isAbsent ? 1.4 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: student.avatarColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  student.initials,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: student.avatarColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Name & Roll
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
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
                                      '${student.rollNumber} • ${student.className}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Interactive Segmented Buttons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Present
                                  _buildSegmentItem(
                                    label: 'Present',
                                    short: 'P',
                                    isActive: isPresent,
                                    color: AppTheme.success,
                                    bgColor: AppTheme.successContainer,
                                    onTap: () => state.setStudentStatus(
                                      student.id,
                                      AttendanceStatus.present,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Absent
                                  _buildSegmentItem(
                                    label: 'Absent',
                                    short: 'A',
                                    isActive: isAbsent,
                                    color: AppTheme.danger,
                                    bgColor: AppTheme.dangerContainer,
                                    onTap: () => state.setStudentStatus(
                                      student.id,
                                      AttendanceStatus.absent,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Late
                                  _buildSegmentItem(
                                    label: 'Late',
                                    short: 'L',
                                    isActive: isLate,
                                    color: AppTheme.warning,
                                    bgColor: AppTheme.warningContainer,
                                    onTap: () => state.setStudentStatus(
                                      student.id,
                                      AttendanceStatus.late,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // Floating Submit Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppTheme.cardBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ResponsiveContainer(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.presentCount} Present • ${state.absentCount} Absent',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Rate: ${state.attendancePercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _submitAttendance(context, state),
                icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                label: const Text('Save Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentItem({
    required String label,
    required String short,
    required bool isActive,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? bgColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? color : AppTheme.cardBorder,
            width: isActive ? 1.6 : 1.0,
          ),
        ),
        child: Text(
          short,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isActive ? color : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}
