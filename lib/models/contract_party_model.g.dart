// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_party_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractPartyAdapter extends TypeAdapter<ContractParty> {
  @override
  final int typeId = 2;

  @override
  ContractParty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractParty(
      fullName: fields[0] as String,
      phone: fields[1] as String,
      address: fields[2] as String,
      role: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContractParty obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractPartyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
