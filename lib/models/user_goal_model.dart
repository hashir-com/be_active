import 'package:hive/hive.dart';

part 'user_goal_model.g.dart';

@HiveType(typeId: 3)
class UserGoalModel extends HiveObject {
  @HiveField(0)
  int? goalIndex;

  @HiveField(1)
  String? workoutPlan;

  @HiveField(2)
  String? dietPlan;

  UserGoalModel({this.goalIndex,
  this.workoutPlan,
    this.dietPlan,});

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
