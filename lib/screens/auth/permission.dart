import 'package:flutter/material.dart';
import 'package:mhealthapp/health/health_package.dart';
import 'package:mhealthapp/screens/home_page.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mhealthapp/services/health_data_sync_service.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool isInstalled = await HealthPermissions.isHealthConnectInstalled();
      if (!isInstalled) {
        setState(() {
          _errorMessage =
              'Health Connect is not installed. Please install "Health Connect by Android" from Google Play';
          _isLoading = false;
        });
        print("Health Connect not installed. Showing dialog.");
        _showHealthConnectDialog();
        return;
      }

      bool granted = await HealthPermissions.requestPermissions();
      print("Health Connect permissions granted: $granted");
      if (granted) {
        if (mounted) {
          await HealthDataSyncService.syncToSQLite();
          await Workmanager().registerPeriodicTask(
            "healthSyncTask",
            "syncHealthData",
            frequency: const Duration(minutes: 30),
          );
          print("Today's periodic task registered");
          await Workmanager().registerPeriodicTask(
            "yesterdayhealthSyncTask",
            "syncYesterdayHealthData",
            frequency: const Duration(hours: 24),
          );
          print("Yesterday's Periodic task registered");

          print("Permissions granted. Navigating to /home");
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        setState(() {
          _errorMessage =
              'Permission denied. Please grant permissions manually in Health Connect';
          _isLoading = false;
        });
        print("Permissions denied in Health Connect");
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error requesting permissions: $e';
        _isLoading = false;
      });
    }
  }

  void _showHealthConnectDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Health Connect Required'),
            content: const Text(
              'Health Connect is Android\'s official health data platform. It needs to be installed to use health features.\n\n'
              'Please search and install "Health Connect by Android" from Google Play Store.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _writeTestData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = await HealthPermissions.writeTestData();
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Test data written successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage =
              'Failed to write test data. Make sure Health Connect is installed and permissions are granted.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error writing test data: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 120,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(height: 32),
                Text(
                  'Health Data Access Permission',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'To provide complete health tracking features, we need access to your health data. This includes:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: const [
                        _PermissionItem(
                          icon: Icons.directions_walk,
                          title: 'Steps and Activity Data',
                          description:
                              'Track your daily activities and exercise',
                        ),
                        SizedBox(height: 12),
                        _PermissionItem(
                          icon: Icons.favorite,
                          title: 'Heart Rate Data',
                          description: 'Monitor your heart rate changes',
                        ),
                        SizedBox(height: 12),
                        _PermissionItem(
                          icon: Icons.monitor_weight,
                          title: 'Weight and Height',
                          description: 'Record changes in your body metrics',
                        ),
                        SizedBox(height: 12),
                        _PermissionItem(
                          icon: Icons.bedtime,
                          title: 'Sleep Data',
                          description: 'Analyze your sleep quality',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Grant Health Data Access',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _writeTestData,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green.shade600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Write Test Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(context, '/home'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Skip to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your health data will be stored securely on your device and will not be uploaded to our servers.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
