import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mkatabafix_app/widgets/contract_form_widget.dart';
import 'package:mkatabafix_app/services/template_service.dart';
import 'package:mkatabafix_app/helpers/storage_helper.dart';
import 'package:mkatabafix_app/helpers/pdf_helper.dart';
import 'package:intl/intl.dart';
import 'package:mkatabafix_app/models/contract_template_model.dart';
import 'package:mkatabafix_app/models/contract_model.dart';
import 'package:uuid/uuid.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  ContractTemplate? _selectedTemplate;
  final TemplateService _templateService = TemplateService();
  final _formKey = GlobalKey<ContractFormWidgetState>();
  bool _showCustomContractForm = false;

  // Image handling
  XFile? _logoImage;
  List<XFile> _contractImages = [];
  final TextEditingController _contractTextController = TextEditingController();

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

    Future.delayed(Duration.zero, () {
      final template =
          ModalRoute.of(context)?.settings.arguments as ContractTemplate?;
      if (template != null) {
        setState(() {
          _selectedTemplate = template;
          _showCustomContractForm = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _contractTextController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isLogo) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isLogo) {
          _logoImage = image;
        } else {
          _contractImages.add(image);
        }
      });
    }
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_logoImage != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(_logoImage!.path)),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_contractImages.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _contractImages.map((image) {
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(image.path)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _contractImages.remove(image);
                        });
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildContractTypeCard(ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Contract Type', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.folder_open_outlined,
                  color: theme.colorScheme.primary),
              title: Text(
                _selectedTemplate == null
                    ? 'Select a Template'
                    : 'Template: ${_selectedTemplate!.title}',
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () async {
                final selected = await Navigator.pushNamed(context, '/templates');
                if (selected is ContractTemplate) {
                  setState(() {
                    _selectedTemplate = selected;
                    _showCustomContractForm = false;
                  });
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.edit_outlined,
                  color: theme.colorScheme.primary),
              title: const Text('Create Custom Contract',
                  style: TextStyle(fontSize: 16)),
              onTap: () {
                setState(() {
                  _selectedTemplate = null;
                  _showCustomContractForm = true;
                });
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contract Details', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        _buildImagePreview(),
        const SizedBox(height: 10),
        if (_showCustomContractForm)
          SizedBox(
            height: 300,
            child: TextFormField(
              controller: _contractTextController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: 'Write your contract here...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          )
        else if (_selectedTemplate != null)
          SizedBox(
            height: 300,
            child: ContractFormWidget(
              key: _formKey,
              template: _selectedTemplate,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Future<Uint8List?> _getImageBytes(String? path) async {
    if (path == null) return null;
    return await File(path).readAsBytes();
  }

  Future<void> _saveContract() async {
    if (_showCustomContractForm) {
      final contractId = const Uuid().v4();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final contract = Contract(
        id: contractId,
        title: 'Custom Contract - $formattedDate',
        type: 'General',
        createdAt: now,
        templateId: null,
        data: {'content': _contractTextController.text},
        fields: {},
        parties: [],
        signatures: {},
        logo: await _getImageBytes(_logoImage?.path),
        photos: await Future.wait(
          _contractImages
              .map((e) => _getImageBytes(e.path))
              .where((e) => e != null)
              .cast<Future<Uint8List>>(),
        ),
      );

      await StorageHelper.saveContract(contract);
      final pdfFile = await PdfHelper.generatePdf({
        'content': _contractTextController.text,
        'logo': await _getImageBytes(_logoImage?.path),
        'images': await Future.wait(
          _contractImages
              .map((e) => _getImageBytes(e.path))
              .where((e) => e != null)
              .cast<Future<Uint8List>>(),
        ),
      });
      print('PDF generated at: ${pdfFile.path}');
      Navigator.pushNamed(context, '/preview');
    } else if (_formKey.currentState != null &&
        _formKey.currentState!.validateForm()) {
      final formData = _formKey.currentState!.getFormData();
      final contractId = const Uuid().v4();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      final contract = Contract(
        id: contractId,
        title: _selectedTemplate?.title ?? 'Contract - $formattedDate',
        type: _selectedTemplate?.type ?? 'General',
        createdAt: now,
        templateId: _selectedTemplate?.id,
        data: formData,
        fields: formData,
        parties: [],
        signatures: {},
        logo: await _getImageBytes(_logoImage?.path),
        photos: await Future.wait(
          _contractImages
              .map((e) => _getImageBytes(e.path))
              .where((e) => e != null)
              .cast<Future<Uint8List>>(),
        ),
      );

      await StorageHelper.saveContract(contract);
      final pdfFile = await PdfHelper.generatePdf(formData);
      print('PDF generated at: ${pdfFile.path}');
      Navigator.pushNamed(context, '/preview');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Removed the AppBar
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
            children: [
              Text(
                'New Contract',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary, // Use primary color from theme
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildContractTypeCard(theme),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildContractForm(theme),
                ),
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                'Add Parties',
                Icons.people_outline,
                () => print('Add Parties tapped'),
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                'Capture Signatures',
                Icons.draw_outlined,
                () => print('Capture Signatures tapped'),
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                'Add Logo',
                Icons.image_outlined,
                () => _pickImage(true),
              ),
              const SizedBox(height: 10),
              _buildActionButton(
                'Add Contract Images',
                Icons.photo_library_outlined,
                () => _pickImage(false),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // Use primary color from theme
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _saveContract,
                child: Text(
                  'Save & Preview',
                  style: TextStyle(color: theme.colorScheme.onPrimary), // Use onPrimary color from theme
                ),
              ),
            ],
          ),
        ),
      ),
      // Removed the bottomNavigationBar
    );
  }
}