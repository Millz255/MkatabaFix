import 'package:hive/hive.dart';
import 'package:mkatabafix_app/models/contract_party_model.dart';

part 'contract_model.g.dart';

@HiveType(typeId: 2)
class Contract {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final List<ContractParty> parties;
  @HiveField(4)
  final Map<String, dynamic> fields;
  @HiveField(5)
  final Map<String, Uint8List> signatures;
  @HiveField(6)
  final Uint8List? logo;
  @HiveField(7)
  final List<Uint8List> photos;
  @HiveField(8)
  final DateTime createdAt;

  Contract({
    required this.id,
    required this.title,
    required this.type,
    required this.parties,
    required this.fields,
    required this.signatures,
    this.logo,
    this.photos = const [],
    required this.createdAt,
  });
}