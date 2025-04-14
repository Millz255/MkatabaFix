import 'package:flutter/material.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart'; // Assuming this path

class ContractFormWidget extends StatefulWidget {
  final ContractTemplate? template;
  final Map<String, dynamic>? initialData; // To populate fields if editing

  const ContractFormWidget({super.key, this.template, this.initialData});

  @override
  ContractFormWidgetState createState() => ContractFormWidgetState();
}

class ContractFormWidgetState extends State<ContractFormWidget> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> _formFields = [];
  Map<String, TextEditingController> _textControllers = {};
  Map<String, dynamic> _formData = {}; // To store data for all field types

  @override
  void initState() {
    super.initState();
    _buildFormFields();
  }

  @override
  void didUpdateWidget(covariant ContractFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.template != widget.template) {
      _buildFormFields();
    }
  }

  void _buildFormFields() {
    _formFields.clear();
    _textControllers.clear();
    _formData.clear();

    if (widget.template != null && widget.template!.fields.isNotEmpty) {
      for (var field in widget.template!.fields) {
        final initialValue = widget.initialData?[field.key];
        Widget formField;

        switch (field.type.toLowerCase()) {
          case 'text':
          case 'number':
            final controller = TextEditingController(text: initialValue?.toString() ?? field.defaultValue);
            _textControllers[field.key] = controller;
            formField = TextFormField(
              controller: controller,
              keyboardType: field.type.toLowerCase() == 'number' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(labelText: field.label),
              validator: (value) => field.required && (value == null || value.isEmpty)
                  ? 'Please enter ${field.label}'
                  : null,
            );
            _formData[field.key] = controller.text; // Initialize form data
            break;
          case 'date':
            final controller = TextEditingController(text: initialValue?.toString() ?? field.defaultValue);
            _textControllers[field.key] = controller;
            formField = InkWell(
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.text.isNotEmpty
                      ? DateTime.parse(controller.text)
                      : DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final formattedDate = selectedDate.toLocal().toString().split(' ')[0];
                  controller.text = formattedDate;
                  setState(() {
                    _formData[field.key] = formattedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(labelText: field.label),
                child: Text(controller.text.isNotEmpty ? controller.text : 'Select Date'),
              ),
            );
            _formData[field.key] = controller.text; // Initialize form data
            break;
          case 'dropdown':
            final options = field.options as List<String>? ?? [];
            String? selectedValue = initialValue?.toString();
            if (selectedValue == null && options.isNotEmpty) {
              selectedValue = options.first; // Set default if available
            }
            _formData[field.key] = selectedValue;
            formField = StatefulBuilder(
              builder: (context, setState) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: field.label),
                  value: selectedValue,
                  items: options.map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  )).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue;
                      _formData[field.key] = newValue;
                    });
                  },
                  validator: (value) => field.required && value == null
                      ? 'Please select ${field.label}'
                      : null,
                );
              },
            );
            break;
          // Add cases for other field types like 'checkbox', 'signature', 'image' here
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
      // You might want to add UI for creating custom fields here if needed
    }
    // Force a rebuild after building fields
    setState(() {});
  }

  Map<String, dynamic> getFormData() {
    final formData = <String, dynamic>{};
    _textControllers.forEach((key, value) {
      formData[key] = value.text;
    });
    // Include data from other field types
    formData.addAll(_formData);
    return formData;
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
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