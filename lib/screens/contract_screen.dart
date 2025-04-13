import 'package:flutter/material.dart';
import 'package:mkatabafix_app/widgets/contract_form_widget.dart';
import 'package:mkatabafix_app/services/template_service.dart';
import 'package:mkatabafix_app/helpers/storage_helper.dart';
import 'package:mkatabafix_app/helpers/pdf_helper.dart';
import 'package:intl/intl.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart';
import 'package:mkatabafix_app/models/contract_model.dart'; // Assuming this path
import 'package:uuid/uuid.dart'; // For generating unique contract IDs
import 'package:intl/intl.dart'; // For date formatting

class ContractScreen extends StatefulWidget {
  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 1; // Index for Contract Screen in BottomNav
  ContractTemplate? _selectedTemplate;
  final TemplateService _templateService = TemplateService();
  final _formKey = GlobalKey<ContractFormWidgetState>();

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

    // Check if a template was passed as an argument
    Future.delayed(Duration.zero, () {
      final template = ModalRoute.of(context)?.settings.arguments as ContractTemplate?;
      if (template != null) {
        setState(() {
          _selectedTemplate = template;
        });
      }
    });
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
          // Current screen
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/templates');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/preview'); // Placeholder route
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
      }
    });
  }

  Widget _buildCard({required Widget child, VoidCallback? onTap}) {
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
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contract'),
      ),
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildCard(
                onTap: () async {
                  final selected = await Navigator.pushNamed(context, '/templates');
                  if (selected is ContractTemplate) {
                    setState(() {
                      _selectedTemplate = selected;
                    });
                  }
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.folder_open_outlined, color: theme.primaryColor),
                    const SizedBox(width: 16.0),
                    Text(
                      _selectedTemplate == null ? 'Select a Template' : 'Template: ${_selectedTemplate!.title}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              _buildCard(
                onTap: () {
                  setState(() {
                    _selectedTemplate = null; // Clear selected template for custom contract
                  });
                  print('Create Custom Contract tapped');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit_outlined, color: theme.primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Create Custom Contract', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Contract Details',
                style: theme.textTheme.headline6,
              ),
              const SizedBox(height: 10.0),
              _buildCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ContractFormWidget(
                    key: _formKey,
                    template: _selectedTemplate,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              _buildCard(
                onTap: () {
                  print('Add Parties tapped');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.people_outline, color: theme.primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Add Parties', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _buildCard(
                onTap: () {
                  print('Capture Signatures tapped');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.draw_outlined, color: theme.primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Capture Signatures', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _buildCard(
                onTap: () {
                  print('Add Images/Logos tapped');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.image_outlined, color: theme.primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Add Images / Logos', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                    final formData = _formKey.currentState!.getFormData();
                    final contractId = const Uuid().v4();
                    final now = DateTime.now();
                    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                    final contract = Contract(
                      id: contractId,
                      title: _selectedTemplate?.title ?? 'Custom Contract - $formattedDate',
                      createdAt: now,
                      templateId: _selectedTemplate?.id,
                      data: formData,
                      // Add other relevant data like parties, signatures, images
                    );

                    await StorageHelper.saveContract(contract);
                    final pdfFile = await PdfHelper.generatePdf(formData);
                    print('PDF generated at: ${pdfFile.path}');
                    Navigator.pushNamed(context, '/preview'); // You might want to pass the contract or PDF file here
                  }
                },
                child: const Text(
                  'Save & Preview',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
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
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}