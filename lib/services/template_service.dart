import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart'; // Assuming this path

class TemplateService {
  Future<List<ContractTemplate>> loadTemplates() async {
    List<ContractTemplate> templates = [];
    final templateFiles = [
      'assets/templates/business_loan_agreement_template.json',
      'assets/templates/car_rent_template.json',
      'assets/templates/debt_repayment_agreement_template.json',
      'assets/templates/employment_contract_template.json',
      'assets/templates/freelance_agreement_template.json',
      'assets/templates/house_rent_template.json',
      'assets/templates/intellectual_property_agreement_template.json',
      'assets/templates/investment_agreement_template.json',
      'assets/templates/loan_contract_template.json',
      'assets/templates/maternity_leave_agreement_template.json',
      'assets/templates/nda_template.json',
      'assets/templates/partnership_agreement_template.json',
      'assets/templates/power_of_attorney_template.json',
      'assets/templates/property_maintenance_agreement_template.json',
      'assets/templates/real_estate_agency_template.json',
      'assets/templates/sale_agreement_template.json',
      'assets/templates/service_agreement_template.json',
      'assets/templates/supplier_agreement_template.json',
      'assets/templates/tenancy_agreement_commercial_template.json',
    ];

    for (final path in templateFiles) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> json = jsonDecode(jsonString);
        templates.add(ContractTemplate.fromJson(json));
      } catch (e) {
        print('Error loading template from $path: $e');
        // Optionally handle the error, e.g., by skipping the file
      }
    }
    return templates;
  }

  // You might add functions to save, update, or manage custom templates later
}

// Extension to parse JSON into ContractTemplate
extension ContractTemplateFromJson on ContractTemplate {
  static ContractTemplate fromJson(Map<String, dynamic> json) {
    return ContractTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      fields: (json['fields'] as List)
          .map((fieldJson) => ContractField.fromJson(fieldJson))
          .toList(),
    );
  }
}

// Assuming ContractField model has a fromJson method as well
extension ContractFieldFromJson on ContractField {
  static ContractField fromJson(Map<String, dynamic> json) {
    return ContractField(
      label: json['label'] as String,
      key: json['key'] as String,
      type: json['type'] as String,
      required: json['required'] as bool? ?? false,
      defaultValue: json['defaultValue'] as String?,
    );
  }
}