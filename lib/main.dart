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
import '/screens/exercise_lib/pre_defined_ex/bicep_curl/bicep_curl.dart';
import 'db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        '/home': (context) => HomePage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(), // Create this next
        '/signup1': (context) => const CreateAccountStep1(),
        '/signup2': (context) => CreateAccountStep2(userData: {}),
        '/signup3': (context) => CreateAccountStep3(userData: {}),
        '/signup4': (context) => CreateAccountStep4(userData: {}),
        '/signup5': (context) => CreateAccountStep5(userData: {}),
        '/signup6': (context) => CreateAccountStep6(userData: {}),
        '/arms': (context) => const ArmsExercisesPage(),
      },
    );
  }
}
