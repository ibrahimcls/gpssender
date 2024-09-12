// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverAdapter extends TypeAdapter<Driver> {
  @override
  final int typeId = 2;

  @override
  Driver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Driver(
      id: fields[0] as int,
      nameSurname: fields[1] as String,
      username: fields[2] as String,
      phoneNumber: fields[3] as String,
      email: fields[4] as String,
      systemRole: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Driver obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameSurname)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.systemRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
