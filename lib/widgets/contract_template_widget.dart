import 'package:flutter/material.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart'; // Assuming this path

class ContractTemplateWidget extends StatelessWidget {
  final ContractTemplate template;
  final VoidCallback? onTap;

  const ContractTemplateWidget({
    super.key,
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                template.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                template.type,
                style: theme.textTheme.subtitle1,
              ),
              // You can add a brief description or more details here if needed
            ],
          ),
        ),
      ),
    );
  }
}