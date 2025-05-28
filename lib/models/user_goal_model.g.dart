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
      workoutPlan: fields[1] as String?,
      dietPlan: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserGoalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.goalIndex)
      ..writeByte(1)
      ..write(obj.workoutPlan)
      ..writeByte(2)
      ..write(obj.dietPlan);
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
