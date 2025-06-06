import 'package:hive/hive.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/models/user_goal_model.dart';

Future<Map<String, int>> getTodayStepsAndGoal() async {
  final stepBox = Hive.box<StepEntry>('step_entries');
  final goalBox = Hive.box<UserGoalModel>('userGoalBox');

  final today = DateTime.now();
  final todayKey =
      DateTime(today.year, today.month, today.day).toIso8601String();

  final stepEntry = stepBox.get(todayKey);
  final stepsToday = stepEntry?.steps ?? 0;

  int dailyGoal = 10000; // default
  final userGoal = goalBox.get('usergoal');

  if (userGoal?.workoutPlans != null && userGoal?.goalIndex != null) {
    dailyGoal = userGoal!.goalIndex!;
  }

  return {'steps': stepsToday, 'goal': dailyGoal};
}
