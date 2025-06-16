import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'steps_model.g.dart';

@HiveType(typeId: 2)
class StepEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int steps;

  @HiveField(2)
  final int stepGoal;

  StepEntry({required this.date, required this.steps, required this.stepGoal});
}
