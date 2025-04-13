import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Assuming this path
import 'package:hive_flutter/hive_flutter.dart'; // For Hive

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  File? _profileImage;
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
    _fullNameController.dispose();
    super.dispose();
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

  Future<void> _saveProfileAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      // Convert File to Uint8List for storing in Hive
      List<int>? imageBytes;
      if (_profileImage != null) {
        imageBytes = await _profileImage!.readAsBytes();
      }

      final userProfile = UserProfile(
        fullName: fullName,
        profileImage: imageBytes != null ? Uint8List.fromList(imageBytes) : null,
      );

      // Store user profile in Hive
      final userProfileBox = await Hive.openBox<UserProfile>('userProfileBox');
      await userProfileBox.put('user', userProfile); // Assuming a single user

      // Navigate to Home Screen
      Navigator.pushReplacementNamed(context, '/home'); // Assuming '/home' is the route for HomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // To access default theme colors

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Animated logo or app title (replace with your actual logo)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'MkatabaFix',
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      // You can add your font family here once defined in main.dart
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
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
                        backgroundColor: theme.primaryColorLight, // Placeholder color
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60.0, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: theme.primaryColor, // Placeholder color
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 20.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
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
                const SizedBox(height: 40.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // Placeholder color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: _saveProfileAndNavigate,
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}