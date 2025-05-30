import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/food_item.dart';
import '../models/user_goal_model.dart';
import '../models/steps_model.dart';
import '../models/workout_model.dart';
import '../models/diet_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WorkoutPlanAdapter());
  Hive.registerAdapter(DietPlanAdapter());
  Hive.registerAdapter(UserGoalModelAdapter());
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(StepEntryAdapter());

  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<UserGoalModel>('userGoalBox');
  await Hive.openBox<DietPlan>('dietPlans');
  await Hive.openBox<WorkoutPlan>('workoutBox');
  await Hive.openBox<FoodItem>('foodBox');
  await Hive.openBox<StepEntry>('stepsBox');
}
