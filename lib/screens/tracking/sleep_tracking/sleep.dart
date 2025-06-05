// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/sleep/sleep_model.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep_dialogs.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep_functions.dart';
import 'package:thryv/util/progress_utils.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final SleepRepository _repo = SleepRepository();

  late SleepGoal _goal;
  late List<SleepEntry> _entries;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Listen to box changes to auto-update UI
    Hive.box<SleepEntry>(
      SleepRepository.sleepBoxName,
    ).listenable().addListener(_loadData);
    Hive.box<SleepGoal>(
      SleepRepository.goalBoxName,
    ).listenable().addListener(_loadData);
  }

  void _loadData() {
    setState(() {
      _goal = _repo.getGoal();
      _entries = _repo.getEntries();
    });

    if (_entries.isNotEmpty) {
      final latestSleepHours = _entries.first.sleepHours;
      if (latestSleepHours >= _goal.hours) {
        Future.delayed(Duration.zero, _onGoalCompleted);
      }
    }
  }

  void _onGoalCompleted() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Goal Achieved! 🎉'),
            content: const Text(
              'You have reached your daily Sleep Hours goal!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nice!'),
              ),
            ],
          ),
    );

    await updateDailyProgress(date: DateTime.now(), type: 'sleep');
  }

  Future<void> _onSetGoal() async {
    final newGoal = await showSetGoalDialog(context, _goal.hours);
    if (newGoal != null) {
      await _repo.setGoal(newGoal);
      _loadData();
    }
  }

  Future<void> _onAddEntry() async {
    final result = await showAddEntryDialog(context);
    if (result != null) {
      final now = DateTime.now();
      final bedTime = result['bedTime']!;
      final wakeUpTime = result['wakeUpTime']!;

      // Handle sleep crossing over midnight
      // final duration =
      //     wakeUpTime.isAfter(bedTime)
      //         ? wakeUpTime.difference(bedTime)
      //         : wakeUpTime.add(const Duration(days: 1)).difference(bedTime);

      // final sleepHours = duration.inMinutes / 60.0;

      final newEntry = SleepEntry(
        date: DateTime(now.year, now.month, now.day),
        bedTime: bedTime,
        wakeUpTime: wakeUpTime,
        // sleepHours: sleepHours.toInt(), // ✅ required field
      );

      await _repo.addEntry(newEntry);
      _loadData();
    }
  }

  double get _latestSleepHours =>
      _entries.isEmpty ? 0 : _entries.first.sleepHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final sleepPercent = (_latestSleepHours / _goal.hours).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Sleep Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddEntry,
            tooltip: 'Add Sleep Entry',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_latestSleepHours.toStringAsFixed(1)}h of ${_goal.hours.toStringAsFixed(1)}h',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _onSetGoal,
                            tooltip: 'Set Sleep Goal',
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(25),
                        minHeight: 10,
                        value: sleepPercent.toDouble(),
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.2,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'Sleep Time',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_entries.isNotEmpty)
                        _buildTimeCard(
                          context,
                          'Bed Time',
                          _formatTime(_entries.first.bedTime),
                        ),
                      if (_entries.isNotEmpty)
                        _buildTimeCard(
                          context,
                          'Wake Up Time',
                          _formatTime(_entries.first.wakeUpTime),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tips to Sleep Better',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sleep Analysis',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 66),
                      SizedBox(
                        height: 220,
                        child: SleepBarChart(entries: _entries, goal: _goal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String title, String time) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: _onAddEntry,
        title: Text(title),
        trailing: Text(
          time,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

class SleepBarChart extends StatelessWidget {
  final List<SleepEntry> entries;
  final SleepGoal goal;

  const SleepBarChart({super.key, required this.entries, required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final spots = <BarChartGroupData>[];

    // Show last 7 days (including today if present)
    final last7 = entries.take(7).toList().reversed.toList();

    for (var i = 0; i < 7; i++) {
      final entry = i < last7.length ? last7[i] : null;
      final value = entry?.sleepHours ?? 0;

      final cappedValue = value.clamp(0, goal.hours).toDouble();

      final barColor =
          value >= goal.hours ? theme.primaryColor : theme.primaryColorLight;

      spots.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: cappedValue,
              color: barColor,
              width: 20,
              borderRadius: BorderRadius.circular(6),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: goal.hours,
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
          ],
          showingTooltipIndicators: value > 0 ? [0] : [],
        ),
      );
    }

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(26),
            tooltipPadding: EdgeInsets.all(5),
            // tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final entry =
                  groupIndex < last7.length ? last7[groupIndex] : null;
              final actualValue = entry?.sleepHours ?? 0;

              return BarTooltipItem(
                '${actualValue.toStringAsFixed(1)} hrs',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),

        maxY: goal.hours,
        minY: 0,
        barGroups: spots,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          rightTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (index, _) {
                final day = DateTime.now().subtract(
                  Duration(days: 7 - index.toInt()),
                );
                final weekday =
                    [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                    ][day.weekday % 7];
                return Text(
                  weekday,
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              reservedSize: 48,
            ),
          ),
          topTitles: AxisTitles(),
        ),
      ),
    );
  }
}
