import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mkatabafix_app/models/contract_model.dart'; // Assuming this path
import 'package:intl/intl.dart'; // For date formatting
import 'package:mkatabafix_app/helpers/storage_helper.dart';
import 'package:mkatabafix_app/helpers/pdf_helper.dart';
import 'package:intl/intl.dart';

class ContractPreviewScreen extends StatefulWidget {
  @override
  _ContractPreviewScreenState createState() => _ContractPreviewScreenState();
}

class _ContractPreviewScreenState extends State<ContractPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 3; // Index for Preview Screen in BottomNav

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/new_contract');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/templates');
          break;
        case 3:
          // Current screen
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
      }
    });
  }

  Widget _buildContractCard(Contract contract) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('yyyy-MM-dd').format(contract.createdAt);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          // Optionally navigate to a detailed view of the contract
          print('View contract: ${contract.id}');
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contract.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Created on: $formattedDate',
                style: theme.textTheme.caption,
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () async {
                      // Generate and potentially show preview
                      final pdfFile = await PdfHelper.generatePdf(contract.data ?? {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('PDF generated at: ${pdfFile.path}')),
                      );
                      // In a real app, you might want to open this PDF or navigate to a PDF viewer screen
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      // Navigate to edit screen, passing the contract data
                      Navigator.pushNamed(context, '/new_contract', arguments: contract);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      // Implement delete functionality
                      await StorageHelper.deleteContract(contract.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contract deleted successfully.')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Contracts'),
      ),
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: ValueListenableBuilder<Box<Contract>>(
          valueListenable: Hive.box<Contract>('contractsBox').listenable(),
          builder: (context, box, _) {
            final contracts = box.values.toList().cast<Contract>();
            if (contracts.isEmpty) {
              return const Center(child: Text('No saved contracts yet.'));
            }
            return ListView.builder(
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                return _buildContractCard(contracts[index]);
              },
            );
          },
        ),
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
            label: 'New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            activeIcon: Icon(Icons.folder_open),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.preview_outlined),
            activeIcon: Icon(Icons.preview),
            label: 'Preview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement functionality to navigate to the contract creation screen
          Navigator.pushNamed(context, '/new_contract');
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Contract',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}