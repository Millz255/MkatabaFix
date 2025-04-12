import 'package:hive/hive.dart';
import 'contract_field_model.dart';

part 'contract_template_model.g.dart';

@HiveType(typeId: 3)
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
}
