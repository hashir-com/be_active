import 'package:hive/hive.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/services/hive_service.dart';

part 'user_goal_model.g.dart';

@HiveType(typeId: 3)
class UserGoalModel extends HiveObject {
  @HiveField(0)
  int? goalIndex;

  @HiveField(1)
  List<WorkoutPlan>? workoutPlans;

  @HiveField(2)
  List<DietPlan>? dietPlans;

  @HiveField(3)
  List<String>? videoIds;

  @HiveField(4)
  int totalCalorieGoal;

  @HiveField(5)
  Map<String, int> mealCalorieGoals;

  UserGoalModel({
    this.goalIndex,
    this.workoutPlans,
    this.dietPlans,
    this.videoIds,
    this.totalCalorieGoal = 1750,
    Map<String, int>? mealCalorieGoals, required goal,
  }) : mealCalorieGoals =
           mealCalorieGoals ??
           {
             'breakfast': 438,
             'morningSnack': 219,
             'lunch': 438,
             'eveningTea': 219,
             'dinner': 438,
           };

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
      return "Maintain";
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
