import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String gender;

  @HiveField(3)
  double height;

  @HiveField(4)
  double weight;

  @HiveField(5)
  int? goalIndex;

  @HiveField(6)
  String? workoutPlan;

  @HiveField(7)
  String? dietPlan;

  @HiveField(8)
  double? bmi;

  @HiveField(9)
  List<Uint8List> images;

  @HiveField(10)
  List<List<String>>? workoutImages;

  UserModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.goalIndex,
    this.workoutPlan,
    this.dietPlan,
    this.bmi,
    List<Uint8List>? images,
    this.workoutImages,
  }) : images = images ?? [];

  UserGoal? get goal => goalIndex != null ? UserGoal.values[goalIndex!] : null;

  set goal(UserGoal? newGoal) => goalIndex = newGoal?.index;
}

enum UserGoal { weightLoss, weightGain, muscleGain }

String userGoalToString(UserGoal goal) {
  switch (goal) {
    case UserGoal.weightLoss:
      return "Weight Loss";
    case UserGoal.weightGain:
      return "Weight Gain";
    case UserGoal.muscleGain:
      return "Muscle Gain";
  }
}

int suggestInitialCalorieGoal(double bmi, UserGoal goal) {
  if (bmi < 18.5 && goal == UserGoal.weightLoss) {
    return 2500;
  }
  if (goal == UserGoal.weightLoss) {
    if (bmi >= 30) return 1600;
    if (bmi >= 25) return 1700;
    return 1800;
  } else if (goal == UserGoal.muscleGain) {
    if (bmi < 18.5) return 2000;
    return 2100;
  } else if (goal == UserGoal.weightGain) {
    if (bmi < 16.5) return 2500;
    return 2300;
  }
  return 2000;
}
