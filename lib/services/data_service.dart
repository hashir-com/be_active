import 'package:hive/hive.dart';
import 'package:thryv/models/food_model.dart/diet_model.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/models/user_goal_model.dart';

class DataService {
  late Box<UserGoalModel> _userGoalBox;
  late Box<UserModel> _userBox;
  late Box<DietPlan> _dietPlansBox;

  UserGoalModel? currentUserGoal;
  UserModel? currentUser;
  DietPlan? currentDiet;

  Future<void> init() async {
    _userGoalBox = Hive.box<UserGoalModel>('userGoalBox');
    _userBox = Hive.box<UserModel>('userBox');
    _dietPlansBox = Hive.box<DietPlan>('dietPlans');

    currentUserGoal = _userGoalBox.get('usergoal') ?? UserGoalModel();
    currentUser = _userBox.get('user');
    currentDiet = _dietPlansBox.get('diet');
  }

  // Save the current user goal.
  Future<void> saveUserGoal() async {
    if (currentUserGoal != null) {
      await _userGoalBox.put('usergoal', currentUserGoal!);
    }
  }

  UserModel? getUser() => currentUser;

  UserGoalModel? getUserGoal() => currentUserGoal;
}
