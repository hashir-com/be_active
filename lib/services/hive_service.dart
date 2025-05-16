import 'package:hive/hive.dart';
import '../models/user_model.dart';

class HiveService {
  late final Box<UserModel> _userBox;

  HiveService() {
    // Get the already opened box here in the constructor
    _userBox = Hive.box<UserModel>('userBox');
  }

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('user', user);
  }

  UserModel? getUser() {
    return _userBox.get('user');
  }
}
