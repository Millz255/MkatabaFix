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
  @HiveField(5)
  final List<String>? options; // Added options property

  ContractField({
    required this.label,
    required this.key,
    required this.type,
    this.required = false,
    this.defaultValue,
    this.options, // Added to constructor
  });

  factory ContractField.fromJson(Map<String, dynamic> json) {
    return ContractField(
      label: json['label'],
      key: json['key'],
      type: json['type'],
      required: json['required'] ?? false,
      defaultValue: json['defaultValue'],
      options: (json['options'] as List<dynamic>?)?.cast<String>(), // Parse options from JSON
    );
  }
}