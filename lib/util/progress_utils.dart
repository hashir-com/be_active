import 'package:hive/hive.dart';
import 'package:thryv/models/daily_progress.dart';

Future<void> updateDailyProgress({
  required DateTime date,
  required String type, // 'food', 'water', 'sleep', 'step'
}) async {
  final box = Hive.box<DailyProgress>('dailyProgressBox');
  final key = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  DailyProgress? progress = box.get(key);

  progress ??= DailyProgress(
      date: DateTime(date.year, date.month, date.day),
      foodLogged: false,
      waterLogged: false,
      sleepLogged: false,
      stepsLogged: false,
    );

  switch (type) {
    case 'food':
      progress.foodLogged = true;
      break;
    case 'water':
      progress.waterLogged = true;
      break;
    case 'sleep':
      progress.sleepLogged = true;
      break;
    case 'step':
      progress.stepsLogged = true;
      break;
  }

  await box.put(key, progress);
}
