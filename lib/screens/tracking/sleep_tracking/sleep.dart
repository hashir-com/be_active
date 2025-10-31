// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/sleep/sleep_model.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep_dialogs.dart';
import 'package:thryv/screens/tracking/sleep_tracking/sleep_functions.dart';
import 'package:thryv/theme/app_colors.dart';
import 'package:thryv/util/progress_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      final newEntry = SleepEntry(
        date: DateTime(now.year, now.month, now.day),
        bedTime: result['bedTime']!,
        wakeUpTime: result['wakeUpTime']!,
      );
      await _repo.addEntry(newEntry);
      _loadData();

      if (_entries.isNotEmpty && _entries.first.sleepHours >= _goal.hours) {
        Future.delayed(Duration.zero, _onGoalCompleted);
      }
    }
  }

  double get _latestSleepHours =>
      _entries.isEmpty ? 0 : _entries.first.sleepHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    final sleepPercent = (_latestSleepHours / _goal.hours).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sleep Tracker',
          style: TextStyle(fontSize: isDesktop ? 20 : 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddEntry,
            tooltip: 'Add Sleep Entry',
          ),
        ],
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12.w : 16.w,
              vertical: isDesktop ? 12.h : 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_latestSleepHours.toStringAsFixed(1)}h of ${_goal.hours.toStringAsFixed(1)}h',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 12.sp : 20.sp,
                      ),
                    ),
                    SizedBox(width: isDesktop ? 6.w : 8.w),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _onSetGoal,
                      tooltip: 'Set Sleep Goal',
                    ),
                  ],
                ),
                SizedBox(height: isDesktop ? 6.h : 8.h),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(25),
                  value: sleepPercent.toDouble(),
                  minHeight: isDesktop ? 16.h : 10.h,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                ),
                SizedBox(height: isDesktop ? 30.h : 16.h),
                Text(
                  'Sleep Time',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 6.sp : 18.sp,
                  ),
                ),
                SizedBox(height: isDesktop ? 6.h : 8.h),
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
                SizedBox(height: isDesktop ? 30.h : 20.h),
                Container(
                  padding: EdgeInsets.all(isDesktop ? 2.w : 16.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips to Sleep Better',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isDesktop ? 5.sp : 18.sp,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 20.h : 6.h),
                      Text(
                        'To improve your sleep quality, exercise daily. Vigorous exercise is best, but even light exercise is better than no activity.',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: isDesktop ? 4.sp : 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isDesktop ? 30.h : 20.h),
                Text(
                  'Sleep Analysis',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 6.sp : 20.sp,
                  ),
                ),
                SizedBox(height: isDesktop ? 60.h : 60.h),
                SizedBox(
                  height: isDesktop ? 350.h : 220.h,
                  child: SleepBarChart(
                    entries: _entries,
                    goal: _goal,
                    isDesktop: isDesktop,
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _onAddEntry();
        },
        child: Icon(
          Icons.bed,
          size: isDesktop ? 28 : 22,
          color: Theme.of(context).highlightColor,
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, String title, String time) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: _onAddEntry,
        title: Text(
          title,
          style: TextStyle(fontSize: isDesktop ? 5.sp : 16.sp),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 5.sp : 16.sp,
          ),
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
  final bool isDesktop;

  const SleepBarChart({
    super.key,
    required this.entries,
    required this.goal,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final last7 = entries.take(7).toList().reversed.toList();

    final spots = List.generate(7, (i) {
      final entry = i < last7.length ? last7[i] : null;
      final value = entry?.sleepHours ?? 0;
      final cappedValue = value.clamp(0, goal.hours).toDouble();
      final barColor =
          value >= goal.hours ? theme.primaryColor : theme.primaryColorLight;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: cappedValue,
            color: barColor,
            width: isDesktop ? 12.w : 20.w,
            borderRadius: BorderRadius.circular(6.r),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: goal.hours,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
        showingTooltipIndicators: value > 0 ? [0] : [],
      );
    });

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBorderRadius: BorderRadius.circular(26.r),
            tooltipPadding: EdgeInsets.all(isDesktop ? 2.w : 5.w),
            getTooltipItem: (group, _, rod, __) {
              final actualValue = entries.asMap()[group.x]?.sleepHours ?? 0;
              return BarTooltipItem(
                '${actualValue.toStringAsFixed(1)} hrs',
                TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 3.sp : 12.sp,
                ),
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
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: isDesktop ? 18.w : 30.w,
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
                  style: TextStyle(fontSize: isDesktop ? 6.sp : 14.sp),
                );
              },
              reservedSize: isDesktop ? 28.h : 30.h,
            ),
          ),
          topTitles: AxisTitles(),
          rightTitles: AxisTitles(),
        ),
      ),
    );
  }
}
