import 'package:be_active/models/user_model.dart';
import 'package:be_active/screens/home_screen.dart';
import 'package:hive/hive.dart';

class HiveService {
  late final Box<UserModel> _userBox;

  HiveService() {
    _userBox = Hive.box<UserModel>('userBox');
  }

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('user', user);
  }

  UserModel? getUser() {
    return _userBox.get('user');
  }

  // ✅ Moved inside the class
  void saveUserGoal(UserGoal goal) {
    final user = getUser();
    if (user != null) {
      user.goal = goal;
      user.save(); // Persist to box
    }
  }

  UserGoal? getUserGoal() {
    final user = getUser();
    return user?.goal;
  }
}
