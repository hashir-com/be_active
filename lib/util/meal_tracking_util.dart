import 'package:hive/hive.dart';
import 'package:thryv/models/food_model.dart/food_item.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/util/progress_utils.dart';

Future<Map<String, num>> getTodayCaloriesAndGoal() async {
  final foodBox = Hive.box<FoodItem>('foodBox');
  final userBox = Hive.box<UserModel>('userBox');
  final goalBox = Hive.box<UserGoalModel>('userGoalBox');

  final user = userBox.get('user');
  final userGoal = goalBox.get('usergoal');

  final today = DateTime.now();
  final totalCalories = foodBox.values
      .where((item) =>
          item.date.year == today.year &&
          item.date.month == today.month &&
          item.date.day == today.day)
      .fold<num>(0, (sum, item) => sum + item.calories);

  num totalGoal = 1750;
  if (user?.bmi != null && userGoal?.goal != null) {
    totalGoal = suggestInitialCalorieGoal(user!.bmi!, userGoal!.goal!);
  }

  return {
    'calories': totalCalories,
    'goal': totalGoal,
  };
}
