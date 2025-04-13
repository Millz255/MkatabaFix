import 'package:hive_flutter/hive_flutter.dart';
import 'package:mkatabafix_app/models/contract_model.dart'; // Assuming this path

class StorageHelper {
  static Future<void> saveContract(Contract contract) async {
    final contractsBox = Hive.box<Contract>('contractsBox');
    await contractsBox.put(contract.id, contract);
  }

  static Contract? getContract(String id) {
    final contractsBox = Hive.box<Contract>('contractsBox');
    return contractsBox.get(id);
  }

  static Future<void> deleteContract(String id) async {
    final contractsBox = Hive.box<Contract>('contractsBox');
    await contractsBox.delete(id);
  }

  static List<Contract> getAllContracts() {
    final contractsBox = Hive.box<Contract>('contractsBox');
    return contractsBox.values.toList();
  }

  // Add more helper functions for other data storage if needed
}