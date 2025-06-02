import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/weight_entry.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  late UserModel user;
  late Box<UserModel> userBox;
  late Box<WeightEntry> weightBox;

  double currentWeight = 0;
  double goalWeight = 0;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserModel>('userBox');
    weightBox = Hive.box<WeightEntry>('weightHistoryBox');
    loadUserData();
  }

  void loadUserData() {
    user = userBox.getAt(0)!;
    if (user.goalWeight == null) {
      user.goalWeight = user.weight;
      user.save();
    }

    currentWeight = user.weight;
    goalWeight = user.goalWeight ?? (user.weight - 5);
  }

  // for firstWhereOrNull

  void updateCurrentWeight(double change) {
    setState(() {
      currentWeight += change;
      user.weight = currentWeight;
      user.save();

      final today = DateTime.now();

      // Try to find today's entry
      final existingTodayEntry = weightBox.values.firstWhereOrNull(
        (entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day,
      );

      if (existingTodayEntry == null) {
        // No entry today, add new
        weightBox.add(WeightEntry(date: today, weight: currentWeight));
      } else {
        // Update existing entry weight
        existingTodayEntry.weight = currentWeight;
        existingTodayEntry.save();
      }
    });
  }

  void updateGoalWeight(double change) {
    setState(() {
      goalWeight += change;
      user.bmi = goalWeight;
      user.save();
    });
  }

  double get progressPercent {
    double? start = user.goalWeight; // initial weight (or starting weight)
    double goal = goalWeight; // goal weight (target weight)

    if (start == null || start <= goal) return 0;

    double lost = start - currentWeight;
    double totalLoss = start - goal;
    return (lost / totalLoss).clamp(0.0, 1.0);
  }

  List<FlSpot> get weightDataSpots {
    final entries =
        weightBox.values.toList()..sort((a, b) => a.date.compareTo(b.date));

    return entries.asMap().entries.map((entry) {
      int index = entry.key;
      WeightEntry e = entry.value;
      return FlSpot(index.toDouble(), e.weight);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDark ? Colors.deepPurpleAccent : Colors.deepPurple;
    final spots = weightDataSpots;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Weight Tracker"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Goal Weight", style: Theme.of(context).textTheme.titleLarge),
          _weightCard(
            weight: goalWeight,
            onDecrement: () => updateGoalWeight(-0.5),
            onIncrement: () => updateGoalWeight(0.5),
          ),
          const SizedBox(height: 16),
          Text("Current Weight", style: Theme.of(context).textTheme.titleLarge),
          _weightCard(
            weight: currentWeight,
            onDecrement: () => updateCurrentWeight(-0.5),
            onIncrement: () => updateCurrentWeight(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            "Weight Loss Progress",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(48),
            value: progressPercent,
            minHeight: 14,
            backgroundColor: Colors.grey.shade300,
            color: themeColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "${(progressPercent * 100).toStringAsFixed(1)}% of goal achieved",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          Text("Weight Graph", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (spots.length <= 1)
            const Center(child: Text("Not enough data to show chart."))
          else
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  minY: spots.map((e) => e.y).reduce(min) - 2,
                  maxY: spots.map((e) => e.y).reduce(max) + 2,
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 4,
                      color: themeColor,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            themeColor.withOpacity(0.4),
                            themeColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              ),
            ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Tip",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weightCard({
    required double weight,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.green),
          onPressed: onDecrement,
        ),
        title: Center(
          child: Text(
            "${weight.toStringAsFixed(1)} kg",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.red),
          onPressed: onIncrement,
        ),
      ),
    );
  }
}
