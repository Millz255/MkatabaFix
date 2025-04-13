import 'package:flutter/material.dart';
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Assuming this path
import 'package:mkatabafix_app/screens/contract_screen.dart'; // Placeholder import
import 'package:mkatabafix_app/screens/template_list_screen.dart'; // Placeholder import
import 'package:mkatabafix_app/screens/contract_preview_screen.dart'; // Placeholder import
import 'package:mkatabafix_app/screens/settings_screen.dart'; // Placeholder import
import 'package:mkatabafix_app/services/user_service.dart'; // Import UserService

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  UserProfile? _userProfile;
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
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await _userService.getUserProfile();
    setState(() {
      _userProfile = userProfile;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  // Widget to display based on the selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Welcome, ${_userProfile?.fullName ?? 'User'}!',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            // Add your font family here
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Ready to create a new contract?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Theme.of(context).primaryColorLight, // Placeholder color
                      backgroundImage: _userProfile?.profileImage != null
                          ? MemoryImage(_userProfile!.profileImage!)
                          : null,
                      child: _userProfile?.profileImage == null
                          ? Icon(Icons.person, size: 30.0, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
              _buildCard(
                onTap: () {
                  _changeTab(1); // Navigate to Contract Screen
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('New Contract', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              _buildCard(
                onTap: () {
                  // Placeholder for Saved Contracts functionality
                  Navigator.pushNamed(context, '/preview');
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.save_outlined, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Saved Contracts', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              _buildCard(
                onTap: () {
                  _changeTab(2); // Navigate to Templates Screen
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.folder_open_outlined, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Templates', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              _buildCard(
                onTap: () {
                  _changeTab(4); // Navigate to Settings Screen
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 16.0),
                    const Text('Settings', style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return ContractScreen(); // Placeholder screen
      case 2:
        return TemplateListScreen(); // Placeholder screen
      case 3:
        return ContractPreviewScreen(); // Placeholder screen
      case 4:
        return SettingsScreen(); // Placeholder screen
      default:
        return Container();
    }
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mkataba Fix'),
      ),
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: _getPage(_selectedIndex),
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
        selectedItemColor: Theme.of(context).primaryColor, // Use your primary color
        unselectedItemColor: Colors.grey,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed, // To show all labels
      ),
    );
  }
}