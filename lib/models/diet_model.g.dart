// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietPlanAdapter extends TypeAdapter<DietPlan> {
  @override
  final int typeId = 5;

  @override
  DietPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietPlan(
      dietName: fields[0] as String?,
      servings: fields[1] as String?,
      calorie: fields[2] as int?,
      mealType: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DietPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dietName)
      ..writeByte(1)
      ..write(obj.servings)
      ..writeByte(2)
      ..write(obj.calorie)
      ..writeByte(3)
      ..write(obj.mealType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
