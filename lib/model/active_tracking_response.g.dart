// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_tracking_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveTrackingResponseAdapter
    extends TypeAdapter<ActiveTrackingResponse> {
  @override
  final int typeId = 3;

  @override
  ActiveTrackingResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveTrackingResponse(
      success: fields[0] as bool,
      message: fields[1] as String?,
      activeTracking: fields[2] as ActiveTracking?,
    );
  }

  @override
  void write(BinaryWriter writer, ActiveTrackingResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.activeTracking);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveTrackingResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
