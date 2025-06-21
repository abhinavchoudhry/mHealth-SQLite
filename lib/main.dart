import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart'; // For activity recognition permission

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Connect Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Health Connect Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _healthDataStatus = 'Initializing Health Connect...';
  List<HealthDataPoint> _healthData = [];
  final Health health = Health();

  // Define the data types your app needs to read and/or write.
  // These must correspond to the permissions declared in AndroidManifest.xml.
  final List<HealthDataType> _readWriteTypes = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.HEART_RATE,
  ];

  @override
  void initState() {
    super.initState();
    _initHealthConnect();
  }

  // Initializes Health Connect and requests permissions.
  Future<void> _initHealthConnect() async {
    setState(() {
      _healthDataStatus = 'Checking Health Connect availability...';
    });

    // Request ACTIVITY_RECOGNITION permission (for steps, etc.)
    // This is a separate Android permission from Health Connect permissions.
    var activityStatus = await Permission.activityRecognition.request();
    if (activityStatus.isDenied) {
      setState(() {
        _healthDataStatus = 'Activity Recognition permission denied.';
      });
      print('Activity Recognition permission denied.');
      return;
    }

    setState(() {
      _healthDataStatus = 'Requesting Health Connect permissions...';
    });

    try {
      // Request permissions for the defined data types.
      // This will open the Health Connect permissions screen for the user.
      bool authorized = await health.requestAuthorization(
        _readWriteTypes,
        permissions: [
          HealthDataAccess.READ_WRITE,
          HealthDataAccess.READ_WRITE,
          HealthDataAccess.READ_WRITE,
        ],
      );

      if (authorized) {
        setState(() {
          _healthDataStatus = 'Health Connect permissions granted.';
        });
        print('Health Connect permissions granted.');
        // Optionally, fetch data immediately after authorization
        _fetchHealthData();
      } else {
        setState(() {
          _healthDataStatus = 'Health Connect permissions denied.';
        });
        print('Health Connect permissions denied.');
      }
    } catch (e) {
      setState(() {
        _healthDataStatus = 'Error during authorization: $e';
      });
      print('Error during authorization: $e');
    }
  }

  // Fetches health data from Health Connect for today.
  Future<void> _fetchHealthData() async {
    setState(() {
      _healthDataStatus = 'Fetching health data...';
      _healthData = []; // Clear previous data
    });

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfToday = now; // Fetch up to the current time

    try {
      List<HealthDataPoint> fetchedData = await health.getHealthDataFromTypes(
        types: _readWriteTypes,
        startTime: startOfDay,
        endTime: endOfToday,
      );

      setState(() {
        _healthData = fetchedData;
        _healthDataStatus = 'Data fetched successfully!';
        if (_healthData.isEmpty) {
          _healthDataStatus = 'No health data found for today.';
        }
      });
    } catch (e) {
      setState(() {
        _healthDataStatus = 'Error fetching health data: $e';
      });
      print('Error fetching health data: $e');
    }
  }

  // Writes a sample step count to Health Connect.
  Future<void> _writeSampleSteps() async {
    setState(() {
      _healthDataStatus = 'Writing sample steps...';
    });

    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute - 5,
    );
    final end = now;
    const int stepsToWrite = 500;

    try {
      bool success = await health.writeHealthData(
        value: stepsToWrite.toDouble(),
        type: HealthDataType.STEPS,
        startTime: start,
        endTime: end,
      );

      if (success) {
        setState(() {
          _healthDataStatus = 'Successfully wrote $stepsToWrite steps.';
        });
        _fetchHealthData(); // Refresh data after writing
      } else {
        setState(() {
          _healthDataStatus = 'Failed to write steps.';
        });
      }
    } catch (e) {
      setState(() {
        _healthDataStatus = 'Error writing steps: $e';
      });
      print('Error writing steps: $e');
    }
  }

  // Writes a sample weight entry to Health Connect.
  Future<void> _writeSampleWeight() async {
    setState(() {
      _healthDataStatus = 'Writing sample weight...';
    });

    final now = DateTime.now();
    const double weightKg = 70.5; // Example weight in kilograms

    try {
      bool success = await health.writeHealthData(
        value: weightKg,
        type: HealthDataType.WEIGHT,
        startTime: now,
        endTime: now,
      );

      if (success) {
        setState(() {
          _healthDataStatus = 'Successfully wrote ${weightKg}kg weight.';
        });
        _fetchHealthData(); // Refresh data after writing
      } else {
        setState(() {
          _healthDataStatus = 'Failed to write weight.';
        });
      }
    } catch (e) {
      setState(() {
        _healthDataStatus = 'Error writing weight: $e';
      });
      print('Error writing weight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _healthDataStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _initHealthConnect,
                  icon: const Icon(Icons.sync),
                  label: const Text('Initialize & Request Permissions'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _fetchHealthData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Fetch Today\'s Data'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _writeSampleSteps,
                  icon: const Icon(Icons.directions_walk),
                  label: const Text('Write 500 Steps'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _writeSampleWeight,
                  icon: const Icon(Icons.monitor_weight),
                  label: const Text('Write 70.5kg Weight'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Fetched Health Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _healthData.isEmpty
                  ? const Center(child: Text('No data points to display.'))
                  : ListView.builder(
                      itemCount: _healthData.length,
                      itemBuilder: (context, index) {
                        final dataPoint = _healthData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type: ${dataPoint.type.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Value: ${dataPoint.value} ${dataPoint.unit.name}',
                                ),
                                Text(
                                  'From: ${DateFormat('yyyy-MM-dd HH:mm').format(dataPoint.dateFrom)}',
                                ),
                                Text(
                                  'To: ${DateFormat('yyyy-MM-dd HH:mm').format(dataPoint.dateTo)}',
                                ),
                                Text(
                                  'Source: ${dataPoint.sourceName} (${dataPoint.sourcePlatform})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
