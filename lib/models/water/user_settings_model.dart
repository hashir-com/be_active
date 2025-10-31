import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 7)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  int waterGoal;

  UserSettingsModel({required this.waterGoal});
}
