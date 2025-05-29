import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'steps_model.g.dart';

@HiveType(typeId: 2)
class StepEntry extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int steps;

  @HiveField(2)
  int stepGoal;

  StepEntry({required this.date, required this.steps, required this.stepGoal});
}
