import 'package:flutter/material.dart';
import '../state/attendance_state.dart';
import '../theme/app_theme.dart';
import '../models/student.dart';
import '../data/sample_data.dart';
import '../widgets/student_card.dart';
import '../widgets/add_student_dialog.dart';
import '../widgets/responsive_container.dart';

/// Full Student Directory Screen with search, class filtering,
/// detailed attendance breakdowns, and enrollment actions.
class StudentsScreen extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const StudentsScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  label: const Text('Mark or Update Attendance'),
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
    final students = state.filteredStudents;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Student Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Add Student',
            onPressed: () => AddStudentDialog.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search bar header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: ResponsiveContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Search TextField
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => state.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search by student name or roll number...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
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
                  const SizedBox(height: 12),

                  // Class filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: SampleData.availableClasses.map((className) {
                        final isSelected = state.selectedClass == className;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(className),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) state.setSelectedClass(className);
                            },
                            backgroundColor: AppTheme.background,
                            selectedColor: AppTheme.primary,
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
                ],
              ),
            ),
          ),
          const Divider(color: AppTheme.cardBorder, height: 1),

          // Total count bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ResponsiveContainer(
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${students.length} students',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (state.lowAttendanceStudents.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${state.lowAttendanceStudents.length} Defaulters (<75%)',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.dangerText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Students list
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No students found',
                          style: const TextStyle(
                            fontSize: 16,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80, top: 4),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return StudentCard(
                          student: student,
                          onTap: () => _showStudentDetails(context, student),
                          onStatusChanged: (newStatus) {
                            state.setStudentStatus(student.id, newStatus);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddStudentDialog.show(context),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Student'),
      ),
    );
  }
}
