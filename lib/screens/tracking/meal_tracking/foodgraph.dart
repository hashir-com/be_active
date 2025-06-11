import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyCalorieChartScreen extends StatelessWidget {
  final Map<DateTime, double> weeklyData; // day -> total calories
  const WeeklyCalorieChartScreen({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    final sortedKeys =
        weeklyData.keys.toList()
          ..sort((a, b) => a.weekday.compareTo(b.weekday));
    final maxY =
        (weeklyData.values
                .fold<double>(0, (a, b) => a > b ? a : b)
                .ceilToDouble() /
            100 *
            100) +
        100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Calorie Intake'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Calorie Intake (Last 7 Days)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine:
                            (value) => FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups:
                          sortedKeys.map((date) {
                            final x = date.weekday - 1;
                            final y = weeklyData[date]!;
                            return BarChartGroupData(
                              x: x,
                              barRods: [
                                BarChartRodData(
                                  toY: y,
                                  width: 20,
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ],
                            );
                          }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameSize: 24,
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const labels = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun',
                              ];
                              final idx = value.toInt();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  idx >= 0 && idx < labels.length
                                      ? labels[idx]
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: const Text(
                            'Calories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          axisNameSize: 28,
                          sideTitles: SideTitles(
                            reservedSize: 30,
                            showTitles: true,
                            interval: maxY / 5,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(0)} Cal',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 5400),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
