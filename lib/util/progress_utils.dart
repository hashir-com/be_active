import 'package:hive/hive.dart';
import 'package:thryv/models/daily_progress.dart';

Future<void> updateDailyProgress({
  required DateTime date,
  required String type, // 'food', 'water', or 'step'
}) async {
  final Box<DailyProgress> box = Hive.box<DailyProgress>('dailyProgressBox');
  final key = "${date.year}-${date.month}-${date.day}";
  DailyProgress? progress = box.get(key);

  progress ??= DailyProgress(date: date);

  if (type == 'food') progress.foodLogged = true;

  if (type == 'water') progress.waterLogged = true;
  if (type == 'step') progress.stepsLogged = true;

  await box.put(key, progress);
}
