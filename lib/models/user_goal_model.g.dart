// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGoalModelAdapter extends TypeAdapter<UserGoalModel> {
  @override
  final int typeId = 3;

  @override
  UserGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserGoalModel(
      goalIndex: fields[0] as int?,
      workoutPlans: (fields[1] as List?)?.cast<WorkoutPlan>(),
      dietPlans: (fields[2] as List?)?.cast<DietPlan>(),
      videoIds: (fields[3] as List?)?.cast<String>(),
      totalCalorieGoal: fields[4] as int,
      mealCalorieGoals: (fields[5] as Map?)?.cast<String, int>(),
      goal: null,
    );
  }

  @override
  void write(BinaryWriter writer, UserGoalModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.goalIndex)
      ..writeByte(1)
      ..write(obj.workoutPlans)
      ..writeByte(2)
      ..write(obj.dietPlans)
      ..writeByte(3)
      ..write(obj.videoIds)
      ..writeByte(4)
      ..write(obj.totalCalorieGoal)
      ..writeByte(5)
      ..write(obj.mealCalorieGoals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
