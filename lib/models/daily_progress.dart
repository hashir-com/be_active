import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'daily_progress.g.dart';

@HiveType(typeId: 12)
class DailyProgress extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  bool foodLogged;

  @HiveField(2)
  bool waterLogged;

  @HiveField(3)
  bool sleepLogged;

  @HiveField(4)
  bool stepsLogged;

  DailyProgress({
    required this.date,
    this.foodLogged = false,
    this.waterLogged = false,
    this.sleepLogged = false,
    this.stepsLogged = false,
  });

  int get completionScore =>
      (foodLogged ? 1 : 0) +
      (waterLogged ? 1 : 0) +
      (sleepLogged ? 1 : 0) +
      (stepsLogged ? 1 : 0);
}
