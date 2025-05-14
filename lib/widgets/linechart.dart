import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressLineChart extends StatelessWidget {
  const ProgressLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text(
                        'Mon',
                        style: TextStyle(color: Colors.white),
                      );
                    case 1:
                      return const Text(
                        'Tue',
                        style: TextStyle(color: Colors.white),
                      );
                    case 2:
                      return const Text(
                        'Wed',
                        style: TextStyle(color: Colors.white),
                      );
                    case 3:
                      return const Text(
                        'Thu',
                        style: TextStyle(color: Colors.white),
                      );
                    case 4:
                      return const Text(
                        'Fri',
                        style: TextStyle(color: Colors.white),
                      );
                    case 5:
                      return const Text(
                        'Sat',
                        style: TextStyle(color: Colors.white),
                      );
                    case 6:
                      return const Text(
                        'Sun',
                        style: TextStyle(color: Colors.white),
                      );
                    default:
                      return const Text(
                        '',
                        style: TextStyle(color: Colors.white),
                      );
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 25,
                interval: 1,
                getTitlesWidget:
                    (value, _) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.white,
              barWidth: 5,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 2.5),
                FlSpot(3, 4),
                FlSpot(4, 3.5),
                FlSpot(5, 4.4),
                FlSpot(6, 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
