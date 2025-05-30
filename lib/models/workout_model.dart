import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'workout_model.g.dart'; // <- this is important for generated code

@HiveType(typeId: 4)  // Use your own unique typeId
class WorkoutPlan extends HiveObject {
  @HiveField(0)
  String? workoutName;

  @HiveField(1)
  String? instruction;

  @HiveField(2)
  String? information;

  @HiveField(3)
  String? imageUrl;

  WorkoutPlan({this.workoutName, this.instruction, this.information, this.imageUrl,});
}
