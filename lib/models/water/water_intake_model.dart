import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'water_intake_model.g.dart';

@HiveType(typeId: 8)
class WaterIntakeModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int glassesDrunk;

  WaterIntakeModel({required this.date, required this.glassesDrunk});
}
