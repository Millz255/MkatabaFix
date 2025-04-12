import 'package:hive/hive.dart';

part 'contract_field_model.g.dart';

@HiveType(typeId: 4)
class ContractField {
  @HiveField(0)
  final String label;

  @HiveField(1)
  final String key;

  @HiveField(2)
  final String type; // e.g., text, number, date

  @HiveField(3)
  final bool required;

  @HiveField(4)
  final String? defaultValue;

  ContractField({
    required this.label,
    required this.key,
    required this.type,
    required this.required,
    this.defaultValue,
  });
}
