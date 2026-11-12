import 'package:flutter/material.dart';
import '../state/attendance_state.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_container.dart';

/// Comprehensive attendance reports and analytics screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _exportReport(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.download_done_rounded, color: AppTheme.success, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Consolidated Attendance Report exported as $format!'),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AttendanceScope.of(context);
    final defaulters = state.lowAttendanceStudents;

    final classStats = [
      {'class': 'CSE-3A', 'rate': 94.2, 'count': 24, 'color': AppTheme.primary},
      {'class': 'ECE-2A', 'rate': 91.0, 'count': 18, 'color': AppTheme.secondary},
      {'class': 'CSE-3B', 'rate': 88.5, 'count': 24, 'color': AppTheme.info},
      {'class': 'IT-4A', 'rate': 86.4, 'count': 16, 'color': AppTheme.warning},
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Attendance Reports & Analytics'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Report',
            onSelected: (format) => _exportReport(context, format),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'PDF',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, color: AppTheme.danger, size: 20),
                    SizedBox(width: 10),
                    Text('Export as PDF Document'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Excel (.xlsx)',
                child: Row(
                  children: [
                    Icon(Icons.table_chart_outlined, color: AppTheme.success, size: 20),
                    SizedBox(width: 10),
                    Text('Export as Excel (.xlsx)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'CSV',
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppTheme.primary, size: 20),
                    SizedBox(width: 10),
                    Text('Export as CSV Sheet'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Analytics Metrics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      title: 'Overall Rate',
                      value: '${state.attendancePercentage.toStringAsFixed(1)}%',
                      icon: Icons.speed_rounded,
                      color: AppTheme.primary,
                      subtext: '+2.1% this week',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      title: 'Top Performing',
                      value: 'CSE-3A (94%)',
                      icon: Icons.workspace_premium_rounded,
                      color: AppTheme.success,
                      subtext: '0 defaulters',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      title: 'Defaulters (<75%)',
                      value: '${defaulters.length} Students',
                      icon: Icons.warning_amber_rounded,
                      color: AppTheme.danger,
                      subtext: 'Requires notification',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      title: 'Total Sessions',
                      value: '46 Recorded',
                      icon: Icons.calendar_month_rounded,
                      color: AppTheme.secondary,
                      subtext: 'Semester V',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Class Comparison Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Batch-Wise Attendance Comparison',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Average semester performance across all departments',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...classStats.map((item) {
                      final rate = item['rate'] as double;
                      final color = item['color'] as Color;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['class'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${rate.toStringAsFixed(1)}% (${item['count']} enrolled)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: rate / 100.0,
                                minHeight: 10,
                                backgroundColor: AppTheme.background,
                                valueColor: AlwaysStoppedAnimation<Color>(color),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Low Attendance Alert Section (< 75%)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppTheme.danger.withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.dangerContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.warning_rounded,
                                color: AppTheme.danger,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attendance Defaulters List',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Mandatory college limit is 75%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.dangerText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.dangerContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${defaulters.length} Flagged',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.dangerText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (defaulters.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Great news! No students are below 75% attendance.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.successText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      ...defaulters.map((s) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.dangerContainer,
                                child: Text(
                                  s.initials,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.dangerText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${s.rollNumber} • ${s.className}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${s.overallAttendance}%',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.danger,
                                    ),
                                  ),
                                  const Text(
                                    'Action needed',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.dangerText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Export simulation button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _exportReport(context, 'PDF Document'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.print_rounded, size: 20),
                  label: const Text('Generate Semester Summary Report'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
