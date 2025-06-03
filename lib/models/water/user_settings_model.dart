import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 7)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  int waterGoal;

  UserSettingsModel({required this.waterGoal});
}
