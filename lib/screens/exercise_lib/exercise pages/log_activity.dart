import 'package:flutter/material.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:mhealthapp/models/log_routine.dart';
import 'package:mhealthapp/screens/ActivityStatus/activity_page.dart';
import '../../Settings/settings_1.dart';
import '../../challenges.dart';
import 'log_workout_popup.dart';
import '/screens/home_page.dart';
import '/screens/exercise.dart';

class LogActivityPage extends StatefulWidget {
  final int userId;

  const LogActivityPage({super.key, required this.userId});

  @override
  State<LogActivityPage> createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {
  final DBHelper _dbHelper = DBHelper();
  List<WorkoutLog> _workoutHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    if (widget.userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final history = await _dbHelper.getRecentWorkoutHistory(widget.userId!);
      setState(() {
        _workoutHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading workout history: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshHistory() async {
    setState(() => _isLoading = true);
    await _loadWorkoutHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.emoji_events_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChallengesPage()),
                );
              },
            ),
            Expanded(
              child: Center(
                child: Text("mHealth", style: TextStyle(color: Colors.black)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ExercisePage()),
                      ),
                ),
                Text(
                  "Log Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Log any workouts you complete here. Recent workouts can be found below. "
                  "A full exercise history can be found in the Activity Stats page.",
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => LogWorkoutPopup(userId: widget.userId!),
                    );

                    // Refresh the history if a workout was logged
                    if (result == true) {
                      await _refreshHistory();
                    }
                  },
                  child: Text(
                    "+ Log a Workout",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Exercise History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                _buildHistoryTable(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          // Navigate to HomePage
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            // Navigate to ExercisePage
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExercisePage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          }
          // Navigate to ChatPage
          // else if (index == 1) {
          // }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    final Color lightPurple = Colors.deepPurple.shade50;
    final Color mediumPurple = Colors.deepPurple.shade100;

    if (_isLoading) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        ),
      );
    }

    if (_workoutHistory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: lightPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.fitness_center,
                size: 48,
                color: Colors.deepPurple.shade300,
              ),
              SizedBox(height: 16),
              Text(
                'No workout history yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tap "Log a Workout" above to get started!',
                style: TextStyle(color: Colors.deepPurple.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: mediumPurple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  children:
                      ["Workout", "Date", "Duration", "Calories"]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                e,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
          // Data rows
          ...List.generate(_workoutHistory.length, (index) {
            final log = _workoutHistory[index];
            final rowColor = index.isEven ? lightPurple : Colors.white;

            return Container(
              decoration: BoxDecoration(
                color: rowColor,
                borderRadius:
                    index == _workoutHistory.length - 1
                        ? BorderRadius.vertical(bottom: Radius.circular(8))
                        : null,
              ),
              child: InkWell(
                onTap: () => _showWorkoutDetails(log),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            log.routineName,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(log.formattedDate),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(log.formattedDuration),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(log.formattedCalories),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showWorkoutDetails(WorkoutLog log) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workout Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow('Routine Name:', log.routineName),
                  _buildDetailRow('Date:', log.formattedDate),
                  _buildDetailRow(
                    'Duration:',
                    log.formattedDuration,
                  ), // Display 24-hour format directly
                  if (log.caloriesBurned != null)
                    _buildDetailRow(
                      'Calories Burned:',
                      '${log.formattedCalories} cal',
                    ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
