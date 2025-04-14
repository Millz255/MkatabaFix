import 'package:flutter/material.dart';
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Assuming this path
import 'package:mkatabafix_app/screens/contract_screen.dart'; // Import
import 'package:mkatabafix_app/screens/template_list_screen.dart'; // Import
import 'package:mkatabafix_app/screens/contract_preview_screen.dart'; // Import
import 'package:mkatabafix_app/screens/settings_screen.dart'; // Import
import 'package:mkatabafix_app/services/user_service.dart'; // Import UserService
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:mkatabafix_app/models/contract_model.dart'; // Import Contract Model
import 'package:intl/intl.dart'; // For date formatting

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

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildRecentContractCard(Contract contract) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('yyyy-MM-dd').format(contract.createdAt);

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/contract_details', arguments: contract);
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contract.title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                'Created on: $formattedDate',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mkataba Fix'),
        elevation: 1, // Subtle shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implement notifications
            },
          ),
        ],
      ),
      body: AnimatedOpacity(
        opacity: _fadeAnimation.value,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome, ${_userProfile?.fullName ?? 'User'}!',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Ready to manage your contracts?',
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    backgroundImage: _userProfile?.profileImage != null
                        ? MemoryImage(_userProfile!.profileImage!)
                        : null,
                    child: _userProfile?.profileImage == null
                        ? Icon(Icons.person_outline, size: 30.0, color: theme.colorScheme.primary)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Text(
                'Recently Created Contracts',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              ValueListenableBuilder<Box<Contract>>(
                valueListenable: Hive.box<Contract>('contractsBox').listenable(),
                builder: (context, box, _) {
                  final contracts = box.values.toList().cast<Contract>();
                  contracts.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by creation date (newest first)
                  final recentContracts = contracts.take(3).toList(); // Display the top 3 recent contracts

                  if (recentContracts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No contracts created yet.'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // To prevent nested scrolling
                    itemCount: recentContracts.length,
                    itemBuilder: (context, index) {
                      return _buildRecentContractCard(recentContracts[index]);
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _changeTab(3); // Navigate to Preview (Saved Contracts)
                  },
                  child: const Text('View All Contracts'),
                ),
              ),
              const SizedBox(height: 24.0),
              // Removed the individual action cards, keeping the bottom navigation
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
                // Current screen
                break;
              case 1:
                Navigator.pushNamed(context, '/new_contract');
                break;
              case 2:
                Navigator.pushNamed(context, '/templates');
                break;
              case 3:
                Navigator.pushNamed(context, '/preview');
                break;
              case 4:
                Navigator.pushNamed(context, '/settings');
                break;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}