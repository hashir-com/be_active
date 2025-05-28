import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  double currentWeight = 80.0;
  double goalWeight = 75.0;

  void _incrementCurrentWeight() {
    setState(() {
      currentWeight += 0.5;
    });
  }

  void _decrementCurrentWeight() {
    setState(() {
      currentWeight -= 0.5;
    });
  }

  void _incrementGoalWeight() {
    setState(() {
      goalWeight += 0.5;
    });
  }

  void _decrementGoalWeight() {
    setState(() {
      goalWeight -= 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Weight Tracker"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Goal", style: TextStyle(fontWeight: FontWeight.bold)),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: IconButton(onPressed: _decrementGoalWeight, icon: const Icon(Icons.remove, color: Colors.green)),
              title: Center(child: Text("${goalWeight.toStringAsFixed(1)}kg", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: IconButton(onPressed: _incrementGoalWeight, icon: const Icon(Icons.add, color: Colors.red)),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Current Weight", style: TextStyle(fontWeight: FontWeight.bold)),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: IconButton(onPressed: _decrementCurrentWeight, icon: const Icon(Icons.remove, color: Colors.green)),
              title: Center(child: Text("${currentWeight.toStringAsFixed(1)}kg", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              trailing: IconButton(onPressed: _incrementCurrentWeight, icon: const Icon(Icons.add, color: Colors.red)),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.deepPurple.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Tip", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Weighted vests can be worn to bump up the intensity of your regular walk. Ensure comfort and safety by wearing a vest that's no more than 5–10% of your bodyweight."),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Weight Graph", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 200, child: WeightLineChart()),
        ],
      ),
    );
  }
}

class WeightLineChart extends StatelessWidget {
  const WeightLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: [
            FlSpot(0, 100),
            FlSpot(1, 97),
            FlSpot(2, 95),
            FlSpot(3, 92),
            FlSpot(4, 88),
            FlSpot(5, 85),
            FlSpot(6, 80),
          ],
          barWidth: 4,
          color: Colors.deepPurple,
          dotData: FlDotData(show: true),
        )
      ],
      minY: 70,
      maxY: 100,
    ));
  }
}
