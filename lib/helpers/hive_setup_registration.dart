import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/daily_progress.dart';
import 'package:thryv/models/sleep/sleep_model.dart';
import 'package:thryv/models/water/user_settings_model.dart';
import 'package:thryv/models/water/water_intake_model.dart';
import 'package:thryv/models/weight_entry.dart';
import '../models/user_model.dart';
import '../models/food_model.dart/food_item.dart';
import '../models/user_goal_model.dart';
import '../models/steps_model.dart';
import '../models/workout_model.dart';
import '../models/food_model.dart/diet_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WorkoutPlanAdapter());
  Hive.registerAdapter(DietPlanAdapter());
  Hive.registerAdapter(UserGoalModelAdapter());
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(StepEntryAdapter());
  Hive.registerAdapter(WeightEntryAdapter());
  Hive.registerAdapter(WaterIntakeModelAdapter());
  Hive.registerAdapter(UserSettingsModelAdapter());
  Hive.registerAdapter(SleepEntryAdapter());
  Hive.registerAdapter(SleepGoalAdapter());
  Hive.registerAdapter(DailyProgressAdapter());

  await Hive.openBox<DailyProgress>('dailyProgressBox');
  await Hive.openBox('settings');
  await Hive.openBox<StepEntry>('step_entries');
  await Hive.openBox<SleepEntry>('sleep_entries');
  await Hive.openBox<SleepGoal>('sleep_goal');
  await Hive.openBox<WaterIntakeModel>('water_intake');
  await Hive.openBox<UserSettingsModel>('user_settings');
  await Hive.openBox<WeightEntry>('weightHistoryBox');
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<UserGoalModel>('userGoalBox');
  await Hive.openBox<DietPlan>('dietPlans');
  await Hive.openBox<WorkoutPlan>('workoutBox');
  await Hive.openBox<FoodItem>('foodBox');
}
