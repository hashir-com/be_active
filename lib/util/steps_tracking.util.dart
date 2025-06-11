import 'package:hive/hive.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/models/user_goal_model.dart';

Future<Map<String, int>> getTodayStepsAndGoal() async {
  late Box settingsBox;
  int dailyGoal;
  settingsBox = Hive.box('settings');
  final stepBox = Hive.box<StepEntry>('step_entries');
  final goalBox = Hive.box<UserGoalModel>('userGoalBox');
  dailyGoal = settingsBox.get('step_goal', defaultValue: 10000);

  final today = DateTime.now();
  final todayKey =
      DateTime(today.year, today.month, today.day).toIso8601String();

  final stepEntry = stepBox.get(todayKey);
  final stepsToday = stepEntry?.steps ?? 0;

  final userGoal = goalBox.get('usergoal');

  if (userGoal?.workoutPlans != null && userGoal?.goalIndex != null) {
    dailyGoal = userGoal!.goalIndex!;
  }

  return {'steps': stepsToday, 'goal': dailyGoal};
}
