import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:thryv/services/hive_service.dart';

part 'diet_model.g.dart'; // important for code generation

@HiveType(typeId: 5) // use a unique typeId different from other models
class DietPlan extends HiveObject {
  @HiveField(0)
  String? dietName;

  @HiveField(1)
  String? servings;

  @HiveField(2)
  int? calorie;

  @HiveField(3)
  String? mealType;

  @HiveField(4)
  Uint8List? dietImageBytes;

  DietPlan({
    this.dietName,
    this.servings,
    this.calorie,
    this.mealType,
    this.dietImageBytes,
  });
}
