import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String gender;

  @HiveField(2)
  int age;

  @HiveField(3)
  double height;

  @HiveField(4)
  double weight;

  UserModel({
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });
}
