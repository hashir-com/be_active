import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: const Text("Sleep Tracker")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "8h 0m of 8h 0m",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: 1, color: Colors.deepPurple),
          const SizedBox(height: 16),
          const Text(
            "Sleep Time",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Bed Time"),
              trailing: const Text("11:00 PM"),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text("Wake Up Time"),
              trailing: const Text("07:00 AM"),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.deepPurple.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips to Sleep Better",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "To improve your sleep quality, exercise daily. *Vigorous exercise is best, but even light exercise is better than no activity.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Sleep Analysis",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 200, child: SleepBarChart()),
        ],
      ),
    );
  }
}

class SleepBarChart extends StatelessWidget {
  const SleepBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                return Text(days[value.toInt()]);
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 8, color: Colors.indigo)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 6, color: Colors.indigo)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 6.5, color: Colors.indigo)],
          ),
        ],
      ),
    );
  }
}
