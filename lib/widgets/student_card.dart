import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme/app_theme.dart';

/// Reusable student card with avatar, attendance health badge,
/// and instant interactive Present / Absent / Late toggle controls.
class StudentCard extends StatelessWidget {
  final Student student;
  final ValueChanged<AttendanceStatus>? onStatusChanged;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.onStatusChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = student.status == AttendanceStatus.present;
    final isAbsent = student.status == AttendanceStatus.absent;
    final isLate = student.status == AttendanceStatus.late;

    // Attendance rate color coding
    final rateColor = student.overallAttendance >= 85
        ? AppTheme.success
        : (student.overallAttendance >= 75 ? AppTheme.warning : AppTheme.danger);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAbsent
              ? AppTheme.danger.withOpacity(0.3)
              : AppTheme.cardBorder,
          width: isAbsent ? 1.4 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar with Initials
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: student.avatarColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  student.initials,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: student.avatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Student details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            student.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Overall attendance rate chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: rateColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${student.overallAttendance.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: rateColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${student.rollNumber} • ${student.className}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Interactive Toggle Controls [P] [A] [L]
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Present Button
                  _buildToggleOption(
                    label: 'P',
                    fullName: 'Present',
                    isActive: isPresent,
                    activeColor: AppTheme.success,
                    activeBg: AppTheme.successContainer,
                    onTap: () => onStatusChanged?.call(AttendanceStatus.present),
                  ),
                  const SizedBox(width: 6),

                  // Absent Button
                  _buildToggleOption(
                    label: 'A',
                    fullName: 'Absent',
                    isActive: isAbsent,
                    activeColor: AppTheme.danger,
                    activeBg: AppTheme.dangerContainer,
                    onTap: () => onStatusChanged?.call(AttendanceStatus.absent),
                  ),
                  const SizedBox(width: 6),

                  // Late Button
                  _buildToggleOption(
                    label: 'L',
                    fullName: 'Late',
                    isActive: isLate,
                    activeColor: AppTheme.warning,
                    activeBg: AppTheme.warningContainer,
                    onTap: () => onStatusChanged?.call(AttendanceStatus.late),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required String fullName,
    required bool isActive,
    required Color activeColor,
    required Color activeBg,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: 'Mark $fullName',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? activeBg : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? activeColor : AppTheme.cardBorder,
              width: isActive ? 1.6 : 1.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isActive ? activeColor : AppTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
