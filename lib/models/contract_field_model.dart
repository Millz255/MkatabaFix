import 'package:hive/hive.dart';

part 'contract_field_model.g.dart';

@HiveType(typeId: 5)
class ContractField {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final String key;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final bool required;
  @HiveField(4)
  final String? defaultValue;

  ContractField({
    required this.label,
    required this.key,
    required this.type,
    this.required = false,
    this.defaultValue,
  });
}