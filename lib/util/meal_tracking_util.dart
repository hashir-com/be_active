import 'package:hive/hive.dart';
import 'package:thryv/models/food_model.dart/food_item.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/user_goal_model.dart';

Future<Map<String, num>> getTodayCaloriesAndGoal() async {
  final foodBox = Hive.box<FoodItem>('foodBox');
  final goalBox = Hive.box<UserGoalModel>('userGoalBox');

  final today = DateTime.now();
  final totalCalories = foodBox.values
      .where((item) =>
          item.date.year == today.year &&
          item.date.month == today.month &&
          item.date.day == today.day)
      .fold<num>(0, (sum, item) => sum + item.calories);

  final userGoal = goalBox.get('usergoal');
  final totalGoal = userGoal?.totalCalorieGoal ?? 1750;

  return {
    'calories': totalCalories,
    'goal': totalGoal,
  };
}
