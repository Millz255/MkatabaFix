import 'package:hive/hive.dart';

part 'contract_party_model.g.dart';

@HiveType(typeId: 3)
class ContractParty {
  @HiveField(0)
  final String fullName;
  @HiveField(1)
  final String? phone;
  @HiveField(2)
  final String? address;
  @HiveField(3)
  final String? role;

  ContractParty({
    required this.fullName,
    this.phone,
    this.address,
    this.role,
  });
}