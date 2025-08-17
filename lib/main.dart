import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/auth/welcome_pg.dart';
import 'screens/auth/login.dart';
import 'screens/auth/create_acc1.dart';
import 'screens/auth/create_acc2.dart';
import 'screens/auth/create_acc3.dart';
import 'screens/auth/create_acc4.dart';
import 'screens/auth/create_acc5.dart';
import 'screens/auth/create_acc6.dart';
import '/screens/exercise_lib/pre_defined_ex/arms_exercises.dart';
import '/screens/exercise_lib/exercise_lib.dart';
import 'screens/exercise.dart';
import 'db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/exercise_lib/exercise pages/create_workout_own.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initDb();
    
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => HomePage(),
        '/login': (context) => const LoginPage(), // Create this next
        '/signup1': (context) => const CreateAccountStep1(),
        '/signup2': (context) => CreateAccountStep2(userData: {}),
        '/signup3': (context) => CreateAccountStep3(userData: {}),
        '/signup4': (context) => CreateAccountStep4(userData: {}),
        '/signup5': (context) => CreateAccountStep5(userData: {}),
        '/signup6': (context) => CreateAccountStep6(userData: {}),
        '/arms': (context) => const ArmsExercisesPage(),
        '/exercise':(context) => const ExercisePage(),
      },

      // Handle routes that need parameters
      onGenerateRoute: (settings) {
        if (settings.name == '/create_routine') {
          final args = settings.arguments as Map<String, dynamic>?;
          final userId = args?['userId'] ?? 1;
          return MaterialPageRoute(
            builder: (context) => BuildRoutinePage(userId: userId),
          );
        }

        if (settings.name == '/exercise_lib') {
          final args = settings.arguments as Map<String, dynamic>?;
          final userId = args?['userId'] ?? 1;
          return MaterialPageRoute(
            builder: (context) => ExerciseLibraryPage(userId: userId),
          );
        }
        return null;
      },

    );
  }
}

// Helper class for navigation
class NavigationHelper {
  static Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('logged_in_user_email');
    
    // If no user is logged in, return default
    if (userEmail == null || userEmail.isEmpty) {
      return null;
    }

    final dbHelper = DBHelper();
    try {
      final user = await dbHelper.getUserByEmail(userEmail);
      return user?['user_dim_id'];
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Store logged-in user (call this after successful login)
  static Future<void> setLoggedInUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_user_email', email);
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('logged_in_user_email');
    return userEmail != null && userEmail.isNotEmpty;
  }

  // Log out user
  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_email');
  }
  
  // Helper method to ensure user is logged in before navigation
  static Future<bool> ensureUserLoggedIn(BuildContext context) async {
    final userId = await getCurrentUserId();
    
    if (userId == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
      return false;
    }
    
    return true;
  }

  // Navigate to create routine
  static Future<void> navigateToCreateRoutine(BuildContext context) async {
    final userId = await getCurrentUserId();
    
    // If no user is logged in, redirect to login
    if (userId == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false, // Clear all previous routes
      );
      return;
    }
    
    Navigator.pushNamed(
      context,
      '/create_routine',
      arguments: {'userId': userId},
    );
  }
}
