import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveService {
  final Box<UserModel> _userBox = Hive.box<UserModel>('userBox');

  void saveUser(UserModel user) {
    _userBox.put('profile', user);
  }

  UserModel? getUser() {
    return _userBox.get('profile');
  }
}
