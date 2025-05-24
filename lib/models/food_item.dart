import 'package:hive/hive.dart';
import 'dart:ffi';

import 'package:Thryv/screens/home_screen.dart';

part 'food_item.g.dart';

@HiveType(typeId: 1)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double calories;

  @HiveField(2)
  final double protein;

  @HiveField(3)
  final double fat;

  @HiveField(4)
  final double carbs;

  @HiveField(5)
  String mealType;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.mealType,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['label'],
      calories: (json['nutrients']['ENERC_KCAL'] ?? 0).toDouble(),
      protein: (json['nutrients']['PROCNT'] ?? 0).toDouble(),
      fat: (json['nutrients']['FAT'] ?? 0).toDouble(),
      carbs: (json['nutrients']['CHOCDF'] ?? 0).toDouble(),
      mealType: 'lunch',
    );
  }
}
