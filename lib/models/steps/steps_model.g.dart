// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepEntryAdapter extends TypeAdapter<StepEntry> {
  @override
  final int typeId = 2;

  @override
  StepEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepEntry(
      date: fields[0] as DateTime,
      steps: fields[1] as int,
      stepGoal: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.stepGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
