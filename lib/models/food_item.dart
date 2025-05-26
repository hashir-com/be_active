import 'package:hive/hive.dart';
import 'dart:ffi';

import 'package:thryv/screens/home_screen.dart';

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
  final double fiber;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  String mealType;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.date,
    required this.mealType,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] ?? {};
    return FoodItem(
      name: json['label'] ?? '',
      calories: (nutrients['ENERC_KCAL'] ?? 0).toDouble(),
      protein: (nutrients['PROCNT'] ?? 0).toDouble(),
      fat: (nutrients['FAT'] ?? 0).toDouble(),
      carbs: (nutrients['CHOCDF'] ?? 0).toDouble(),
      fiber: (nutrients['FIBTG'] ?? 0).toDouble(),
      date: DateTime.now(),
      mealType: 'lunch',
    );
  }
}
