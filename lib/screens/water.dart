import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int glassesDrunk = 6;
  final int totalGlasses = 11;

  void _incrementGlass() {
    if (glassesDrunk < totalGlasses) {
      setState(() {
        glassesDrunk++;
      });
    }
  }

  void _decrementGlass() {
    if (glassesDrunk > 0) {
      setState(() {
        glassesDrunk--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = glassesDrunk / totalGlasses;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Water Tracker"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "$glassesDrunk of $totalGlasses Glasses",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress, color: Colors.deepPurple),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(radius: 80, backgroundColor: Colors.blue.shade100),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue.shade300,
                  child: const Icon(Icons.local_drink, size: 30, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "1 Glass (250 ml)",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: _decrementGlass, icon: const Icon(Icons.remove)),
              IconButton(onPressed: _incrementGlass, icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Daily Water Intake", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 200, child: WaterBarChart()),
        ],
      ),
    );
  }
}

class WaterBarChart extends StatelessWidget {
  const WaterBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
              const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              return Text(days[value.toInt()]);
            }),
          ),
        ),
        barGroups: List.generate(7, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [BarChartRodData(toY: (index + 1) * 1.0, color: Colors.blue.shade700)],
          );
        }),
      ),
    );
  }
}
