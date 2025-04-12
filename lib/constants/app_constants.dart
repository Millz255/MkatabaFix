// App Constants

// App Name and Description
const String appName = 'MkatabaFix';
const String appDescription = 'A contract generation app for various contract templates';

// User Profile Constants
const String defaultProfilePicture = 'assets/images/profile_picture.png';
const String defaultLogo = 'assets/images/default_logo.png';

// Contract Template Types
const String contractTypeRent = 'House Rent';
const String contractTypeLoan = 'Loan Agreement';
const String contractTypeCarRent = 'Car Rent';

// File Paths
const String contractTemplatesPath = 'assets/templates/';
const String userProfilesPath = 'assets/images/';

// Default Texts
const String welcomeText = 'Welcome to $appName!';
const String onboardingDescription = 'Please complete your profile to continue.';
const String homeScreenTitle = 'Home';
const String savedContractsTitle = 'Saved Contracts';
const String newContractButton = 'New Contract';
const String templatesButton = 'Templates';
const String settingsButton = 'Settings';
const String contractPreviewButton = 'Preview Contract';
const String editButton = 'Edit';

// Colors (for consistent UI theme)
const int primaryColor = 0xFF008F3B; // Dark Green (from darkGreenSwatch 500)
const int secondaryColor = 0xFF70BF89; // Light Green (from darkGreenSwatch 200)
const int backgroundColor = 0xFFF8F8F8; // Light Grey (same as in main.dart)
const int buttonColor = 0xFF008F3B; // Dark Green for buttons (same as primaryColor)

// App Theme (Colors matching darkGreenSwatch from main.dart)
const Map<int, Color> appColors = {
  50: Color(0xFFE1F2E5),    // Light Green (from darkGreenSwatch 50)
  100: Color(0xFFB3DEC0),   // Light Green (from darkGreenSwatch 100)
  200: Color(0xFF80C899),   // Light Green (from darkGreenSwatch 200)
  300: Color(0xFF4DB172),   // Medium Green (from darkGreenSwatch 300)
  400: Color(0xFF269F55),   // Medium Green (from darkGreenSwatch 400)
  500: Color(0xFF008F3B),   // Primary Dark Green (from darkGreenSwatch 500)
  600: Color(0xFF007E35),   // Dark Green (from darkGreenSwatch 600)
  700: Color(0xFF00692B),   // Dark Green (from darkGreenSwatch 700)
  800: Color(0xFF005522),   // Dark Green (from darkGreenSwatch 800)
  900: Color(0xFF003A16),   // Dark Green (from darkGreenSwatch 900)
};

// Signature Constants (for capturing signatures)
const String signatureCaptureText = 'Sign here';

// Max Field Lengths (for validation)
const int maxFieldLength = 255;
const int minPasswordLength = 6;
const int maxPasswordLength = 24;

// Default Values for Forms
const String defaultFormFieldValue = 'Enter value';
const String requiredFieldText = 'This field is required';

// PDF Export Constants
const String pdfFileNamePrefix = 'Contract_';
const String pdfExportPath = 'contracts/exports/';

// Hive Boxes
const String userProfileBox = 'userProfileBox';
const String contractsBox = 'contractsBox';

// Others
const String appVersion = '1.0.0'; // Change to match actual version
