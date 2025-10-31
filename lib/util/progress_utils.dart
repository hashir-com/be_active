import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/heatmap/daily_progress.dart';

Future<void> updateDailyProgress({
  required DateTime date,
  required String type,
  bool completed = true,
}) async {
  final progressBox = Hive.box<DailyProgress>('dailyProgressBox');
  final key = DateFormat('yyyy-MM-dd').format(date);
  final existing = progressBox.get(key) ?? DailyProgress(date: date);

  switch (type) {
    case 'food':
      existing.foodLogged = completed;
      break;
    case 'water':
      existing.waterLogged = completed;
      break;
    case 'sleep':
      existing.sleepLogged = completed;
      break;
    case 'steps':
      existing.stepsLogged = completed;
      break;
  }

  await progressBox.put(key, existing);
}
