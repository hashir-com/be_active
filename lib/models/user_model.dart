import 'dart:ffi';

import 'package:be_active/screens/home_screen.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart'; // If not already present

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
  });

  UserGoal? get goal => goalIndex != null ? UserGoal.values[goalIndex!] : null;

  set goal(UserGoal? newGoal) => goalIndex = newGoal?.index;
}
