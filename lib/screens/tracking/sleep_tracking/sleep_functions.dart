import 'package:hive/hive.dart';
import 'package:thryv/models/sleep/sleep_model.dart';

class SleepRepository {
  static const sleepBoxName = 'sleep_entries';
  static const goalBoxName = 'sleep_goal';

  final Box<SleepEntry> _sleepBox = Hive.box<SleepEntry>(sleepBoxName);
  final Box<SleepGoal> _goalBox = Hive.box<SleepGoal>(goalBoxName);

  SleepGoal getGoal() {
    if (_goalBox.isEmpty) {
      final defaultGoal = SleepGoal(hours: 8);
      _goalBox.put('goal', defaultGoal);
      return defaultGoal;
    }
    return _goalBox.get('goal')!;
  }

  Future<void> setGoal(double hours) async {
    final goal = SleepGoal(hours: hours);
    await _goalBox.put('goal', goal);
  }

  List<SleepEntry> getEntries() {
    return _sleepBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addEntry(SleepEntry entry) async {
    final entries = _sleepBox.values.where(
      (e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day,
    );

    for (final existing in entries) {
      await existing.delete();
    }

    await _sleepBox.add(entry);
  }
}
