// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/weight_entry.dart';
import 'package:thryv/models/user_goal_model.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  late UserModel user;
  UserGoalModel? userGoalModel;

  late Box<UserModel> userBox;
  late Box<WeightEntry> weightBox;
  late Box<UserGoalModel> userGoalBox;

  double currentWeight = 0;
  double goalWeight = 0;
  double bmi = 0;

  bool showTrackingUI = false;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserModel>('userBox');
    weightBox = Hive.box<WeightEntry>('weightHistoryBox');
    userGoalBox = Hive.box<UserGoalModel>('userGoalBox');

    if (userBox.isNotEmpty) {
      user = userBox.getAt(0)!;
      currentWeight = user.weight;
    } else {
      debugPrint("User box is empty");
      return;
    }

    if (userGoalBox.isNotEmpty) {
      userGoalModel = userGoalBox.getAt(0)!;
      showTrackingUI = true;
      _changeGoal(userGoalModel?.goal);
      loadUserData();
    } else {
      showTrackingUI = false;
    }
  }

  void loadUserData() {
    if (user.height != null && user.height! > 0) {
      bmi = user.weight / ((user.height! / 100) * (user.height! / 100));
    }

    if (user.startingWeight == null) {
      user.startingWeight = user.weight;
      user.save();
    }

    // ✅ Only suggest if goalWeight is null, not every time
    if (user.goalWeight == null) {
      double suggested = user.weight;
      switch (userGoalModel?.goal) {
        case UserGoal.weightLoss:
          suggested = user.weight - 5;
          break;
        case UserGoal.weightGain:
          suggested = user.weight + 15;
          break;
        case UserGoal.muscleGain:
          suggested = user.weight;
          break;
        default:
          suggested = user.weight;
      }
      user.goalWeight = suggested;
      user.save();
    }

    // ✅ Only suggest calorieGoal if it's not set
    if ((userGoalModel?.goal != null) &&
        (userGoalModel?.totalCalorieGoal == 0)) {
      userGoalModel?.totalCalorieGoal = suggestInitialCalorieGoal(
        bmi,
        userGoalModel?.goal ?? UserGoal.weightLoss,
      );
      userGoalModel?.save();
    }

    // ✅ Load saved weights
    currentWeight = user.weight;
    goalWeight = user.goalWeight!;
  }

  void updateCurrentWeight(double change) {
    setState(() {
      currentWeight += change;
      user.weight = currentWeight;
      user.save();

      final today = DateTime.now();
      final existingTodayEntry = weightBox.values.firstWhereOrNull(
        (entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day,
      );

      if (existingTodayEntry == null) {
        weightBox.add(WeightEntry(date: today, weight: currentWeight));
      } else {
        existingTodayEntry.weight = currentWeight;
        existingTodayEntry.save();
      }
    });
  }

  void updateGoalWeight(double change) {
    setState(() {
      goalWeight += change;
      user.goalWeight = goalWeight;
      user.save();
    });
  }

  double get progressPercent {
    double? start = user.startingWeight;
    double? goal = user.goalWeight;

    if (start == null || goal == null || userGoalModel?.goal == null) {
      return 0.0;
    }

    final goalType = userGoalModel!.goal!;
    final weight = currentWeight;

    double progress = 0.0;

    switch (goalType) {
      case UserGoal.weightLoss:
        if (start <= goal || weight <= goal) return 1.0;
        progress = (start - weight) / (start - goal);
        break;

      case UserGoal.weightGain:
      case UserGoal.muscleGain:
        if (start >= goal || weight >= goal) return 1.0;
        progress = (weight - start) / (goal - start);
        break;
    }

    return progress.clamp(0.0, 1.0);
  }

  String _goalLabel() {
    switch (userGoalModel?.goal) {
      case UserGoal.weightLoss:
        return "Weight Loss";
      case UserGoal.weightGain:
        return "Weight Gain";
      case UserGoal.muscleGain:
        return "Maintain";
      default:
        return "No Goal Set";
    }
  }

  Color _progressColor(bool isDark) {
    switch (userGoalModel?.goal) {
      case UserGoal.weightLoss:
        return isDark ? Colors.deepPurpleAccent : Colors.deepPurple;
      case UserGoal.weightGain:
        return Colors.orange;
      case UserGoal.muscleGain:
        return Colors.blue;
      default:
        return isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    }
  }

  void _changeGoal(UserGoal? newGoal) {
    if (newGoal == null) return;

    setState(() {
      userGoalModel?.goal = newGoal;
      userGoalModel?.totalCalorieGoal = suggestInitialCalorieGoal(bmi, newGoal);
      userGoalModel?.save();

      // ✅ Only set goalWeight if it's not already set
      if (user.goalWeight == null) {
        switch (newGoal) {
          case UserGoal.weightLoss:
            goalWeight = 24.5 * ((user.height! / 100) * (user.height! / 100));
            break;
          case UserGoal.weightGain:
            goalWeight = 24.5 * ((user.height! / 100) * (user.height! / 100));
            break;
          case UserGoal.muscleGain:
            goalWeight = user.weight;
            break;
        }

        user.goalWeight = goalWeight;
        user.save();
      }

      // But always reload the local state
      goalWeight = user.goalWeight!;
    });
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
    final themeColor = _progressColor(isDark);
    final spots = weightDataSpots;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Weight Tracker"),
      ),
      body:
      // showTrackingUI
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text(
                "Your Goal: ${_goalLabel()}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 12),
            ],
          ),
          if (userGoalModel?.goal == null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(
                "No goal selected. Default values shown. Please set a goal.",

                style: TextStyle(
                  color: Colors.redAccent,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text("Goal Weight", style: Theme.of(context).textTheme.titleLarge),
          _weightCard(
            weight: goalWeight,
            onDecrement:
                userGoalModel?.goal != null
                    ? () => updateGoalWeight(-0.5)
                    : () {},
            onIncrement:
                userGoalModel?.goal != null
                    ? () => updateGoalWeight(0.5)
                    : () {},
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
            "Progress Towards ${_goalLabel().toUpperCase()}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progressPercent),
            duration: const Duration(milliseconds: 600),
            builder:
                (context, value, _) => LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(8),
                  value: value,
                  minHeight: 14,
                  backgroundColor: Colors.grey.shade300,
                  color: themeColor,
                ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "${(progressPercent * 100).toStringAsFixed(1)}% of ${_goalLabel()} goal achieved",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          Text("Weight Graph", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (spots.isEmpty)
            const Center(child: Text("Not enough data to show chart."))
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    minY: spots.map((e) => e.y).reduce(min) - 2,
                    maxY: spots.map((e) => e.y).reduce(max) + 2,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              value.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 50,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 5,
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
                  "General Tip",
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
      // : Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Text(
      //       "To track weight, let the admin suggest a goal.",
      //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
      //         color: Colors.redAccent,
      //         fontStyle: FontStyle.italic,
      //       ),
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      // ),
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
