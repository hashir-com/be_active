import 'package:hive/hive.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/models/user_goal_model.dart';

Future<Map<String, int>> getTodayStepsAndGoal() async {
  final settingsBox = Hive.box('settings');
  final stepBox = Hive.box<StepEntry>('step_entries');

  // Default to value from settings box (updated by your _editGoal method)
  int dailyGoal = settingsBox.get('step_goal', defaultValue: 10000);

  final today = DateTime.now();
  final todayKey =
      DateTime(today.year, today.month, today.day).toIso8601String();

  final stepEntry = stepBox.get(todayKey);
  final stepsToday = stepEntry?.steps ?? 0;

  // Optionally override from userGoal if stepGoal is defined
  final userGoal = stepBox.get('usergoal');
  if (userGoal?.stepGoal != null && userGoal!.stepGoal > 0) {
    dailyGoal = userGoal.stepGoal;
  }

  return {'steps': stepsToday, 'goal': dailyGoal};
}
