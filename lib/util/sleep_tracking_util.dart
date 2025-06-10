import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/sleep/sleep_model.dart';
import 'package:collection/collection.dart';

Future<Map<String, double>> getTodaySleepAndGoal() async {
  try {
    final sleepBox = Hive.box<SleepEntry>('sleep_entries');
    final goalBox = Hive.box<SleepGoal>('sleep_goal');

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final todayEntry = sleepBox.values.firstWhereOrNull((e) {
      final entryDate = DateTime(
        e.bedTime.year,
        e.bedTime.month,
        e.bedTime.day,
      );
      return entryDate == todayDate;
    });

    final goal = goalBox.get('goal')?.hours ?? 8.0;

    if (todayEntry != null) {
      return {'sleep': todayEntry.sleepHours, 'goal': goal};
    } else {
      return {'sleep': 0.0, 'goal': goal};
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching sleep data: $e');
    }
    return {'sleep': 0.0, 'goal': 8.0};
  }
}
