import 'package:flutter/material.dart';
import 'package:mhealthapp/health/health_package.dart';
import 'package:mhealthapp/screens/home_page.dart';
import 'package:mhealthapp/screens/auth/permission.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mhealthapp/services/health_data_sync_service.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool? _hasPermissions;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Future<void> addStepsForLastTwoWeeks() async {
  //   final now = DateTime.now();

  //   for (int i = 0; i < 14; i++) {
  //     // Calculate the day
  //     final day = now.subtract(Duration(days: i));

  //     // Simulate a random number of steps between 5,000 and 12,000
  //     final simulatedSteps = 5000 + (i * 300) % 7000;
  //     // or: Random().nextInt(7000) + 5000 if you want randomness

  //     // Assume steps happened from 8:00 AM to 8:00 PM of that day
  //     final start = DateTime(day.year, day.month, day.day, 8, 0);
  //     final end = DateTime(day.year, day.month, day.day, 20, 0);

  //     // Call your existing writeSteps function
  //     final success = await HealthAPI.addSteps(
  //       simulatedSteps,
  //       start: start,
  //       end: end,
  //     );

  //     if (success) {
  //       print("Added $simulatedSteps steps for ${start.toLocal()}");
  //     } else {
  //       print("Failed to add steps for ${start.toLocal()}");
  //     }
  //   }
  // }

  Future<void> _checkPermissions() async {
    setState(() {
      _isChecking = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final granted = await HealthPermissions.checkPermissions();
      print("Permissions check result: $granted");
      if (granted) {
        await HealthDataSyncService.syncToSQLite();
        await Workmanager().registerPeriodicTask(
          "healthSyncTask",
          "syncHealthData",
          frequency: const Duration(minutes: 30),
        );
        print("today's Periodic task registered");
        await Workmanager().registerPeriodicTask(
          "yesterdayhealthSyncTask",
          "syncYesterdayHealthData",
          frequency: const Duration(hours: 24),
        );
        print("yesterday's Periodic task registered");
      } else {
        print("Permissions not granted, skipping task registration.");
      }
      ;
      setState(() {
        _hasPermissions = granted;
        _isChecking = false;
      });
      print(
        " State updated: _hasPermissions=$_hasPermissions, _isChecking=$_isChecking",
      );
    } catch (e) {
      setState(() {
        _hasPermissions = false;
        _isChecking = false;
      });
      print("error while checking permissions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || _hasPermissions == null) {
      return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 80,
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 24),
              Text(
                'Health Data Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Initializing...',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }
    return _hasPermissions! ? HomePage() : const PermissionPage();
  }
}
