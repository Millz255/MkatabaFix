// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractTemplateAdapter extends TypeAdapter<ContractTemplate> {
  @override
  final int typeId = 4;

  @override
  ContractTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractTemplate(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      fields: (fields[3] as List).cast<ContractField>(),
    );
  }

  @override
  void write(BinaryWriter writer, ContractTemplate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.fields);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
