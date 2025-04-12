import 'package:flutter/material.dart';

void main() {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mkataba Fix',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Mkataba Fix Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
