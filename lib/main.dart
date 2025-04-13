import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mkatabafix_app/screens/onboarding_screen.dart';
import 'package:mkatabafix_app/screens/home_screen.dart';
import 'package:mkatabafix_app/screens/contract_screen.dart';
import 'package:mkatabafix_app/screens/template_list_screen.dart';
import 'package:mkatabafix_app/screens/contract_preview_screen.dart';
import 'package:mkatabafix_app/screens/settings_screen.dart';
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Import the model
import 'package:mkatabafix_app/models/contract_model.dart'; // Assuming this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter()); // Register the UserProfile adapter
  Hive.registerAdapter(ContractAdapter()); // Assuming you have a ContractAdapter
  await Hive.openBox<UserProfile>('userProfileBox');
  await Hive.openBox<Contract>('contractsBox'); // Open the contracts box

  runApp(const MyApp());
}


// Custom MaterialColor for Dark Green
const MaterialColor darkGreenSwatch = MaterialColor(
  0xFF006400,
  <int, Color>{
    50: Color(0xFFE1F2E5),
    100: Color(0xFFB3DEC0),
    200: Color(0xFF80C899),
    300: Color(0xFF4DB172),
    400: Color(0xFF269F55),
    500: Color(0xFF008F3B),
    600: Color(0xFF007E35),
    700: Color(0xFF00692B),
    800: Color(0xFF005522),
    900: Color(0xFF003A16),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      primarySwatch: darkGreenSwatch,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F8F8),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF003A16) : darkGreenSwatch,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkGreenSwatch,
        foregroundColor: Colors.white,
      ),
      textTheme: _buildTextTheme(brightness),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: darkGreenSwatch,
        brightness: brightness,
      ),
    );
  }

  TextTheme _buildTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF003300),
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : const Color(0xFF145A2D),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFF70BF89) : darkGreenSwatch,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black87,
      ),
      subtitle1: TextStyle( // Added subtitle1 for consistency
        fontSize: 16,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mkataba Fix',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const InitialScreen(), // Use InitialScreen to check for existing profile
      routes: {
        '/home': (context) => HomeScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/new_contract': (context) => ContractScreen(),
        '/templates': (context) => TemplateListScreen(),
        '/preview': (context) => ContractPreviewScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    final userProfileBox = Hive.box<UserProfile>('userProfileBox');
    final userProfile = userProfileBox.get('user');

    // Simulate a delay for a smoother transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (userProfile != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a splash screen or loading indicator here
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}