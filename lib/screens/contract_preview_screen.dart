import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mkatabafix_app/models/contract_model.dart';
import 'package:intl/intl.dart';
import 'package:mkatabafix_app/helpers/storage_helper.dart';
import 'package:mkatabafix_app/helpers/pdf_helper.dart';

class ContractPreviewScreen extends StatefulWidget {
  @override
  _ContractPreviewScreenState createState() => _ContractPreviewScreenState();
}

class _ContractPreviewScreenState extends State<ContractPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Contracts'),
        elevation: 1,
      ),
      body: ValueListenableBuilder<Box<Contract>>(
        valueListenable: Hive.box<Contract>('contractsBox').listenable(),
        builder: (context, box, _) {
          final contracts = box.values.toList().cast<Contract>();
          if (contracts.isEmpty) {
            return Center(
              child: Text('No saved contracts yet.', style: theme.textTheme.titleMedium),
            );
          }
          return ListView.builder(
            itemCount: contracts.length,
            itemBuilder: (context, index) {
              final contract = contracts[index];
              return _buildContractCard(contract, theme);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            activeIcon: Icon(Icons.add),
            label: 'New Contract',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            activeIcon: Icon(Icons.folder_open),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save_outlined),
            activeIcon: Icon(Icons.save),
            label: 'Saved Contracts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 3, // Assuming 'Saved Contracts' is the 4th item (index 3)
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/new_contract');
              break;
            case 2:
              Navigator.pushNamed(context, '/templates');
              break;
            case 3:
              // Current screen
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildContractCard(Contract contract, ThemeData theme) {
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(contract.createdAt);
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white, // Explicitly set the background color of the Card
    child: ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/contract_details', arguments: contract);
      },
      leading: Icon(Icons.description_outlined, color: theme.colorScheme.secondary),
      title: Text(
        contract.title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.black), // Explicitly set text color
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'Created on: $formattedDate',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[800]), // Explicitly set text color
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            Navigator.pushNamed(context, '/new_contract', arguments: contract);
          } else if (value == 'delete') {
            _deleteContract(contract);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit', style: TextStyle(color: Colors.black)), // Explicitly set text color
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete', style: TextStyle(color: Colors.black)), // Explicitly set text color
          ),
        ],
      ),
    ),
  );
}

  void _deleteContract(Contract contract) async {
    final box = Hive.box<Contract>('contractsBox');
    await box.delete(contract.key);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contract "${contract.title}" deleted successfully.')),
    );
  }
}