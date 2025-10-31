import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'workout_model.g.dart'; // <- required for code generation

@HiveType(typeId: 4) // Keep your current unique typeId
class WorkoutPlan extends HiveObject {
  @HiveField(0)
  String? workoutName;

  @HiveField(1)
  String? instruction;

  @HiveField(2)
  String? information;

  @HiveField(3)
  Uint8List? dietImageBytes;

  // New fields
  @HiveField(4)
  int? sets;

  @HiveField(5)
  String? unitType; // "time" or "reps"

  @HiveField(6)
  String? unitValue; // e.g., "10 reps" or "30 min"

  WorkoutPlan({
    this.workoutName,
    this.instruction,
    this.information,
    this.dietImageBytes,
    this.sets,
    this.unitType,
    this.unitValue,
  });
}
