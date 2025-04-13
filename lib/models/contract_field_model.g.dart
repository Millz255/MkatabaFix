// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_field_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractFieldAdapter extends TypeAdapter<ContractField> {
  @override
  final int typeId = 5;

  @override
  ContractField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractField(
      label: fields[0] as String,
      key: fields[1] as String,
      type: fields[2] as String,
      required: fields[3] as bool,
      defaultValue: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContractField obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.required)
      ..writeByte(4)
      ..write(obj.defaultValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
