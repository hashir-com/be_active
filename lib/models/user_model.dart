import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String gender;

  @HiveField(3)
  double height;

  @HiveField(4)
  double weight;

  @HiveField(5)
  double? bmi;

  @HiveField(6)
  double? goalWeight;

  @HiveField(7)
  double? startingWeight; // Add this line

  UserModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.bmi,
    this.goalWeight,
    this.startingWeight,
  });
}
