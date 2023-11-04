// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarAdapter extends TypeAdapter<Calendar> {
  @override
  final int typeId = 0;

  @override
  Calendar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calendar(
      day: fields[0] as DateTime,
      title: fields[1] as String,
      content: fields[2] as String,
      categoryId: fields[3] as int,
    )
      ..isDone = fields[4] as bool
      ..isAlarm = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Calendar obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.isDone)
      ..writeByte(5)
      ..write(obj.isAlarm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
