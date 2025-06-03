// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepEntryAdapter extends TypeAdapter<SleepEntry> {
  @override
  final int typeId = 10;

  @override
  SleepEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepEntry(
      date: fields[0] as DateTime,
      bedTime: fields[1] as DateTime,
      wakeUpTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SleepEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.bedTime)
      ..writeByte(2)
      ..write(obj.wakeUpTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepGoalAdapter extends TypeAdapter<SleepGoal> {
  @override
  final int typeId = 11;

  @override
  SleepGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepGoal(
      hours: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SleepGoal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
