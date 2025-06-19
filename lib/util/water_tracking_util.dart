import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:thryv/models/water/water_intake_model.dart';
import 'package:thryv/models/water/user_settings_model.dart';

Future<Map<String, int>> getTodayWaterIntakeAndGoal() async {
  final waterBox = Hive.box<WaterIntakeModel>('water_intake');
  final settingsBox = Hive.box<UserSettingsModel>('user_settings');

  final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final todayData = waterBox.get(todayKey);
  final goalModel = settingsBox.get('goal');

  final glassesDrunk = todayData?.glassesDrunk ?? 0;
  final waterGoal = goalModel?.waterGoal ?? 8;

  return {'intake': glassesDrunk, 'goal': waterGoal};
}
