import 'package:flutter/material.dart';
import 'package:mhealthapp/health/health_package.dart';

class HealthDashboard extends StatefulWidget {
  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  HealthSummary? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    // try {
    //   // Ensure permissions
    //   // bool hasPerms = await HealthAPI.ensurePermissions();
    //   // if (!hasPerms) {
    //   //   setState(() => _loading = false);
    //   //   return;
    //   }

    // Load today's summary
    HealthSummary summary = await HealthAPI.getTodaySummary();
    setState(() {
      _summary = summary;
      _loading = false;
    });
    // } catch (e) {
    //   print('Error loading health data: $e');
    //   setState(() => _loading = false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_summary == null) {
      return Center(child: Text('No health data available'));
    }

    return Column(
      children: [
        _buildHealthCard(
          'Steps',
          '${_summary!.totalSteps}',
          Icons.directions_walk,
        ),
        _buildHealthCard(
          'Distance',
          '${_summary!.totalDistance.toStringAsFixed(2)} km',
          Icons.straighten,
        ),
        _buildHealthCard(
          'Calories',
          '${_summary!.totalCalories}',
          Icons.local_fire_department,
        ),
        _buildHealthCard(
          'Heart Rate',
          '${_summary!.averageHeartRate} BPM',
          Icons.favorite,
        ),
        _buildHealthCard(
          'Sleep',
          '${_summary!.sleepHours.toStringAsFixed(1)} hours',
          Icons.bedtime,
        ),
      ],
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
