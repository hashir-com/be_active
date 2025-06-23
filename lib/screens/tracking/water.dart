// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/water/water_intake_model.dart';
import 'package:thryv/models/water/user_settings_model.dart';
import 'package:thryv/theme/app_colors.dart';
import 'package:thryv/util/progress_utils.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final waterBox = Hive.box<WaterIntakeModel>('water_intake');
  final settingsBox = Hive.box<UserSettingsModel>('user_settings');

  int waterGoal = 8;
  int glassesDrunk = 0;
  bool _goalDialogShown = false;

  @override
  void initState() {
    super.initState();
    _loadTodayIntake();
    _loadUserGoal();
  }

  DateTime? _lastCheckedDate;

  void _loadTodayIntake() {
    final todayDate = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(todayDate);
    final today = waterBox.get(todayKey);

    if (_lastCheckedDate == null || !_isSameDay(_lastCheckedDate!, todayDate)) {
      _goalDialogShown = false; // reset flag if new day
      _lastCheckedDate = todayDate;
    }

    final currentGlasses = today?.glassesDrunk ?? 0;

    setState(() {
      glassesDrunk = currentGlasses;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _loadUserGoal() {
    final goalModel = settingsBox.get('goal');
    setState(() {
      waterGoal = goalModel?.waterGoal ?? 8;
    });
  }

  void _updateIntake(int change) async {
    setState(() {
      glassesDrunk += change;
      glassesDrunk = glassesDrunk.clamp(0, waterGoal);
    });

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayModel = WaterIntakeModel(
      date: DateTime.now(),
      glassesDrunk: glassesDrunk,
    );
    waterBox.put(todayKey, todayModel);

    final completed = glassesDrunk >= waterGoal;

    await updateDailyProgress(
      date: DateTime.now(),
      type: 'water',
      completed: completed,
    );

    if (completed && !_goalDialogShown) {
      _goalDialogShown = true;
      _onGoalCompleted();
    }
  }

  void _onGoalCompleted() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Goal Achieved! 🎉'),
            content: const Text(
              'You have reached your daily Water intake goal!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nice!'),
              ),
            ],
          ),
    );
  }

  void _changeGoal() async {
    final controller = TextEditingController(text: waterGoal.toString());
    final newGoal = await showDialog<int>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Change Water Goal'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter new goal (glasses)",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final value = int.tryParse(controller.text);
                  if (value != null && value > 0) {
                    settingsBox.put(
                      'goal',
                      UserSettingsModel(waterGoal: value),
                    );
                    Navigator.pop(ctx, value);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
    if (newGoal != null) {
      setState(() => waterGoal = newGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = glassesDrunk / waterGoal;
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Tracker',
          style: TextStyle(fontSize: isDesktop ? 20 : 26),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 4,
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$glassesDrunk / $waterGoal Glasses",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _changeGoal,
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: 'Edit Goal',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 18,
                        borderRadius: BorderRadius.circular(10),
                        color: theme.primaryColorDark,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          "${(progress * 100).toInt()}%",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle background
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColorLight.withOpacity(0.15),
                  ),
                ),
                // Progress fill circle
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: glassesDrunk / waterGoal,
                    strokeWidth: 20,
                    backgroundColor: theme.primaryColorLight.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(theme.primaryColorDark),
                  ),
                ),
                // Icon in the center
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColorLight,
                  ),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text("1 Glass = 250 ml", style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _updateIntake(-1),
                icon: const Icon(Icons.remove_circle, size: 32),
                tooltip: 'Remove Glass',
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () => _updateIntake(1),
                icon: const Icon(Icons.add_circle, size: 32),
                tooltip: 'Add Glass',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "General Tip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Drinking water before meals can help with portion control. Stay hydrated to support your metabolism!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "This Week",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 200, child: WaterBarChart(waterGoal: waterGoal)),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class WaterBarChart extends StatelessWidget {
  final int waterGoal;

  const WaterBarChart({super.key, required this.waterGoal});

  Color getStepColor(int intake, int waterGoal, BuildContext context) {
    final ratio = intake / waterGoal;
    if (ratio >= 1.0) return Theme.of(context).primaryColor;
    if (ratio >= 0.75) return const Color.fromARGB(255, 0, 42, 255);
    if (ratio >= 0.5) return Theme.of(context).primaryColorLight;
    if (ratio >= 0.25) return const Color.fromARGB(255, 255, 135, 55);
    return const Color.fromARGB(255, 255, 17, 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final waterBox = Hive.box<WaterIntakeModel>('water_intake');

    return ValueListenableBuilder(
      valueListenable: waterBox.listenable(),
      builder: (context, Box<WaterIntakeModel> box, _) {
        final today = DateTime.now();
        List<BarChartGroupData> barGroups = [];

        for (int i = 6; i >= 0; i--) {
          final day = today.subtract(Duration(days: i));
          final key = DateFormat('yyyy-MM-dd').format(day);
          final intake = box.get(key)?.glassesDrunk ?? 0;

          barGroups.add(
            BarChartGroupData(
              x: 6 - i,
              barRods: [
                BarChartRodData(
                  toY: intake.toDouble(),
                  width: 18,
                  color: getStepColor(intake, waterGoal, context),
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: waterGoal.toDouble(), // ✅ Use goal here
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          );
        }

        return BarChart(
          BarChartData(
            barGroups: barGroups,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, _) {
                    final date = today.subtract(
                      Duration(days: 6 - value.toInt()),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('E').format(date),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        );
      },
    );
  }
}
