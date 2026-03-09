import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';

class WeeklyTrendChart extends StatelessWidget {
  const WeeklyTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final weekData = _getWeekData();

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
              child: LineChart(
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

  List<FlSpot> _getWeekData() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final entries = StorageService.getSymptomEntriesForDate(day);
      if (entries.isNotEmpty) {
        final avg = entries.map((e) => e.overallRating).reduce((a, b) => a + b) /
            entries.length;
        spots.add(FlSpot(i.toDouble(), avg));
      } else {
        // Mock data for demo
        spots.add(FlSpot(i.toDouble(), _mockValue(i)));
      }
    }
    return spots;
  }

  double _mockValue(int dayIndex) {
    const mockValues = [3.5, 4.0, 2.5, 3.0, 4.5, 3.8, 4.2];
    return mockValues[dayIndex % mockValues.length];
  }
}

