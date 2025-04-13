import 'package:flutter/material.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart'; // Assuming this path

class ContractFormWidget extends StatefulWidget {
  final ContractTemplate? template;
  // You might need to pass initial data if editing an existing contract

  const ContractFormWidget({super.key, this.template});

  @override
  _ContractFormWidgetState createState() => _ContractFormWidgetState();
}

class _ContractFormWidgetState extends State<ContractFormWidget> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> _formFields = [];
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _buildFormFields();
  }

  void _buildFormFields() {
    if (widget.template != null && widget.template!.fields.isNotEmpty) {
      for (var field in widget.template!.fields) {
        final controller = TextEditingController(text: field.defaultValue);
        _controllers[field.key] = controller;
        Widget formField;
        switch (field.type) {
          case 'text':
            formField = TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: field.label),
              validator: (value) => field.required && (value == null || value.isEmpty) ? 'Please enter ${field.label}' : null,
            );
            break;
          case 'number':
            formField = TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: field.label),
              validator: (value) => field.required && (value == null || value.isEmpty) ? 'Please enter ${field.label}' : null,
            );
            break;
          case 'date':
            formField = InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  controller.text = selectedDate.toLocal().toString().split(' ')[0];
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(labelText: field.label),
                child: Text(controller.text.isNotEmpty ? controller.text : 'Select Date'),
              ),
            );
            break;
          default:
            formField = Text('Unknown field type: ${field.type}');
        }
        _formFields.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: formField,
        ));
      }
    } else {
      _formFields.add(const Text('No template selected or template has no fields.'));
      // You might want to add UI for creating custom fields here
    }
  }

  Map<String, dynamic> getFormData() {
    final formData = <String, dynamic>{};
    _controllers.forEach((key, value) {
      formData[key] = value.text;
    });
    return formData;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _formFields,
      ),
    );
  }
}