import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Assuming this path
import 'package:mkatabafix_app/services/user_service.dart'; // Import UserService
import 'package:hive_flutter/hive_flutter.dart'; // For Hive (still used for ValueListenableBuilder if needed elsewhere)
import 'package:url_launcher/url_launcher_string.dart'; // For opening email
import 'package:package_info_plus/package_info_plus.dart'; // For app version (add dependency to pubspec.yaml)

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 4; // Index for Settings Screen in BottomNav
  UserProfile? _userProfile;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  File? _profileImage;
  bool _isDarkMode = false; // Placeholder for theme mode
  final UserService _userService = UserService(); // Instantiate UserService

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
    _loadUserProfile();
    _loadAppVersion();
  }

  Future<void> _loadUserProfile() async {
    final profile = await _userService.getUserProfile();
    setState(() {
      _userProfile = profile;
      _fullNameController.text = _userProfile?.fullName ?? '';
      if (_userProfile?.profileImage != null) {
        // Convert Uint8List back to File for display (if needed)
        // This might not be the most efficient way, consider using MemoryImage directly in UI
        // For now, we'll keep it as Uint8List in the model and use MemoryImage
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      List<int>? imageBytes;
      if (_profileImage != null) {
        imageBytes = await _profileImage!.readAsBytes();
      }

      final updatedProfile = UserProfile(
        fullName: fullName,
        profileImage: imageBytes != null ? Uint8List.fromList(imageBytes) : _userProfile?.profileImage,
      );

      await _userService.saveUserProfile(updatedProfile);
      setState(() {
        _userProfile = updatedProfile; // Update local state
        _profileImage = null; // Reset picked image
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _loadAppVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _openSupportEmail() async {
    const email = 'mgimwaemily@gmail.com';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: <String, String>{
        'subject': 'MkatabaFix App Support Query',
      }.toString(),
    );

    if (await canLaunchUrlString(emailLaunchUri.toString())) {
      await launchUrlString(emailLaunchUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app.')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
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
          Navigator.pushReplacementNamed(context, '/preview');
          break;
        case 4:
          // Current screen
          break;
      }
    });
  }

  Widget _buildSettingCard({required Widget child}) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildSettingCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Edit Profile', style: theme.textTheme.headline6),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take a picture'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from gallery'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60.0,
                            backgroundColor: theme.primaryColorLight,
                            backgroundImage: _userProfile?.profileImage != null
                                ? MemoryImage(_userProfile!.profileImage!)
                                : null,
                            child: _userProfile?.profileImage == null
                                ? Icon(Icons.person, size: 60.0, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 20.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Profile'),
                    ),
                  ],
                ),
              ),
              _buildSettingCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Dark Mode', style: TextStyle(fontSize: 18.0)),
                    Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                          // Implement theme change logic here (e.g., using Provider)
                        });
                      },
                    ),
                  ],
                ),
              ),
              _buildSettingCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('App Version', style: TextStyle(fontSize: 18.0)),
                    Text(_packageInfo.version, style: const TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              _buildSettingCard(
                child: InkWell(
                  onTap: _openSupportEmail,
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.support_agent_outlined),
                      SizedBox(width: 16.0),
                      Text('Support', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              ),
              _buildSettingCard(
                child: InkWell(
                  onTap: () {
                    // Implement Privacy Policy navigation
                    print('Privacy Policy tapped');
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.privacy_tip_outlined),
                      SizedBox(width: 16.0),
                      Text('Privacy Policy', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              ),
              _buildSettingCard(
                child: InkWell(
                  onTap: () {
                    // Implement Terms of Service navigation
                    print('Terms of Service tapped');
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.description_outlined),
                      SizedBox(width: 16.0),
                      Text('Terms of Service', style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                ),
              ),
              // Add more settings options as needed
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}