import 'package:hive/hive.dart';
import 'package:mkatabafix_app/models/contract_field_model.dart';

part 'contract_template_model.g.dart';

@HiveType(typeId: 4)
class ContractTemplate {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final List<ContractField> fields;

  ContractTemplate({
    required this.id,
    required this.title,
    required this.type,
    required this.fields,
  });

  factory ContractTemplate.fromJson(Map<String, dynamic> json) {
    return ContractTemplate(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      fields: (json['fields'] as List).map((item) => ContractField.fromJson(item)).toList(),
    );
  }
}