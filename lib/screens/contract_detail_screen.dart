import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkatabafix_app/models/contract_model.dart'; // Assuming this path
import 'dart:typed_data';
import 'package:mkatabafix_app/helpers/pdf_helper.dart'; // Make sure this is imported
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class ContractDetailScreen extends StatelessWidget {
  const ContractDetailScreen({super.key, required this.contract});

  final Contract contract;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('dd MMMM<ctrl98>, HH:mm').format(contract.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contract Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 1, // Subtle shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print Contract',
            onPressed: () async {
              // Implement printing functionality here using the 'printing' plugin
              await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async =>
                    await PdfHelper.generatePdfBytes(contract.data ?? {}),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contract Title
            Text(
              contract.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            // Creation Date
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Created on: $formattedDate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contract Content (Assuming 'data' is a Map with key-value pairs)
            if (contract.data != null && contract.data!.isNotEmpty) ...[
              Text(
                'Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: contract.data!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toString().replaceAll('_', ' ').capitalizeFirstLetter(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.value.toString(),
                              style: theme.textTheme.bodyLarge,
                            ),
                            if (contract.data!.entries.last != entry)
                              const Divider(height: 20),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Contract Logo (Optional)
            if (contract.logo != null) ...[
              Text(
                'Logo',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Image.memory(
                  contract.logo!,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Contract Images (Optional)
            if (contract.photos != null && contract.photos!.isNotEmpty) ...[
              Text(
                'Images',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: contract.photos!.map((photo) {
                  return SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Add more sections here for parties, signatures, etc. if needed

            const SizedBox(height: 40), // Add some padding at the bottom
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          PdfHelper.generatePdf(contract.data ?? {}).then((pdfFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF generated at: ${pdfFile.path}')),
            );
            // In a real app, you might want to offer options to view or share the PDF
          });
        },
        icon: const Icon(Icons.download_outlined),
        label: const Text('Download PDF'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}