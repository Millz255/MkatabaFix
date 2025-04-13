// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractAdapter extends TypeAdapter<Contract> {
  @override
  final int typeId = 2;

  @override
  Contract read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contract(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      parties: (fields[3] as List).cast<InvalidType>(),
      fields: (fields[4] as Map).cast<String, dynamic>(),
      signatures: (fields[5] as Map).cast<String, InvalidType>(),
      logo: fields[6] as InvalidType,
      photos: (fields[7] as List).cast<InvalidType>(),
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Contract obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.parties)
      ..writeByte(4)
      ..write(obj.fields)
      ..writeByte(5)
      ..write(obj.signatures)
      ..writeByte(6)
      ..write(obj.logo)
      ..writeByte(7)
      ..write(obj.photos)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
