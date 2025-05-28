import 'package:hive/hive.dart';

part 'diet_model.g.dart'; // important for code generation

@HiveType(typeId: 5)  // use a unique typeId different from other models
class DietPlan extends HiveObject {
  @HiveField(0)
  String? dietName;

  @HiveField(1)
  int? servings;

  @HiveField(2)
  int? calorie;

  DietPlan({this.dietName, this.servings, this.calorie});
}
