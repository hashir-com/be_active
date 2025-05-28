import 'package:thryv/models/user_model.dart';
import 'package:thryv/screens/home/home_screen.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/user_goal_model.dart';

class HiveService {
  late final Box<UserModel> _userBox;
  late final Box<UserGoalModel> _userGoalBox;

  HiveService() {
    _userBox = Hive.box<UserModel>('userBox');
    _userGoalBox = Hive.box<UserGoalModel>('userGoalBox');
  }

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('user', user);

  }

  UserModel? getUser() {
    return _userBox.get('user');
  }
   UserGoalModel? getUserGoal() {
    return _userGoalBox.get('usergoal');
  }

  // ✅ Moved inside the class
  void saveUserGoal(UserGoal goal) {
    final user = getUserGoal();
    if (user != null) {
      user.goal = goal;
      user.save(); // Persist to box
    }
  }
}
