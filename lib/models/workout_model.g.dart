// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 4;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      workoutName: fields[0] as String?,
      instruction: fields[1] as String?,
      information: fields[2] as String?,
      dietImageBytes: fields[3] as Uint8List?,
      sets: fields[4] as int?,
      unitType: fields[5] as String?,
      unitValue: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.workoutName)
      ..writeByte(1)
      ..write(obj.instruction)
      ..writeByte(2)
      ..write(obj.information)
      ..writeByte(3)
      ..write(obj.dietImageBytes)
      ..writeByte(4)
      ..write(obj.sets)
      ..writeByte(5)
      ..write(obj.unitType)
      ..writeByte(6)
      ..write(obj.unitValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
