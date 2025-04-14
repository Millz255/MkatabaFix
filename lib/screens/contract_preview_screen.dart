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

class _ContractPreviewScreenState extends State<ContractPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  void _viewContract(Contract contract) async {
    // Open the contract for preview/edit
    Navigator.pushNamed(context, '/contract_detail', arguments: contract);
  }

  Widget _buildContractCard(Contract contract) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('yyyy-MM-dd').format(contract.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: theme.colorScheme.surfaceVariant,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _viewContract(contract),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      contract.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Created: $formattedDate',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () async {
                      final pdfFile =
                          await PdfHelper.generatePdf(contract.data ?? {});
                      // In a real app, open the PDF viewer here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('PDF generated'),
                          backgroundColor: theme.colorScheme.primaryContainer,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_contract',
                          arguments: contract);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () async {
                      await _confirmDelete(contract);
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

  Future<void> _confirmDelete(Contract contract) async {
    final theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contract'),
          content: Text('Are you sure you want to delete "${contract.title}"?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text('Delete'),
              onPressed: () async {
                await StorageHelper.deleteContract(contract.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contract deleted'),
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                'Contract Review',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Contract>>(
                valueListenable:
                    Hive.box<Contract>('contractsBox').listenable(),
                builder: (context, box, _) {
                  final contracts = box.values.toList().cast<Contract>();
                  if (contracts.isEmpty) {
                    return Center(
                      child: Text(
                        'No contracts found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: contracts.length,
                    itemBuilder: (context, index) {
                      return _buildContractCard(contracts[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}