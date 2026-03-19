import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/symptoms_provider.dart';

class WeeklyTrendChart extends ConsumerWidget {
  const WeeklyTrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(symptomsProvider);
    final weekData = _getWeekData(entries);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Týždenný trend refluxu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: weekData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Zatiaľ nemáte žiadne záznamy\npre tento týždeň',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.divider.withValues(alpha: 0.5),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                const days = ['Po', 'Ut', 'St', 'Št', 'Pi', 'So', 'Ne'];
                                final index = value.toInt();
                                if (index >= 0 && index < days.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      days[index],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 0,
                        maxY: 5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: weekData,
                            isCurved: true,
                            color: AppColors.riskMedium,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, xPercentage, bar, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.surface,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.riskMedium,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.riskMedium.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getWeekData(List entries) {
    final now = DateTime.now();
    // Monday as start of week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final day = DateTime(monday.year, monday.month, monday.day).add(Duration(days: i));
      
      final dayEntries = entries.where((e) {
        final d = e.timestamp;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      }).toList();

      if (dayEntries.isNotEmpty) {
        final avg = dayEntries.map((e) => e.overallRating).reduce((a, b) => a + b) /
            dayEntries.length;
        spots.add(FlSpot(i.toDouble(), avg.toDouble()));
      }
    }
    return spots;
  }
}
