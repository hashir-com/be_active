// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyProgressAdapter extends TypeAdapter<DailyProgress> {
  @override
  final int typeId = 12;

  @override
  DailyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyProgress(
      date: fields[0] as DateTime,
      foodLogged: fields[1] as bool,
      waterLogged: fields[2] as bool,
      sleepLogged: fields[3] as bool,
      stepsLogged: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.foodLogged)
      ..writeByte(2)
      ..write(obj.waterLogged)
      ..writeByte(3)
      ..write(obj.sleepLogged)
      ..writeByte(4)
      ..write(obj.stepsLogged);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
