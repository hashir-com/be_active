import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'sleep_model.g.dart';

@HiveType(typeId: 10)
class SleepEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final DateTime bedTime;

  @HiveField(2)
  final DateTime wakeUpTime;

  SleepEntry({
    required this.date,
    required this.bedTime,
    required this.wakeUpTime,
  });

 double get sleepHours {
  DateTime adjustedWake = wakeUpTime;
  if (wakeUpTime.isBefore(bedTime)) {
    adjustedWake = wakeUpTime.add(const Duration(days: 1));
  }
  return adjustedWake.difference(bedTime).inMinutes / 60.0;
}

}

@HiveType(typeId: 11)
class SleepGoal extends HiveObject {
  @HiveField(0)
  double hours;

  SleepGoal({required this.hours});
}
