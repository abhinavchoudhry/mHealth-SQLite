import 'package:flutter/material.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:mhealthapp/main.dart';
import 'package:mhealthapp/models/exercise_models.dart';
import 'package:mhealthapp/models/workout_routine.dart';
import '../Settings/settings_1.dart';
import '../challenges.dart';
import '/screens/home_page.dart';

class ExerciseLibraryPage extends StatefulWidget {
  final int userId;

  const ExerciseLibraryPage({
    super.key,
    required this.userId,
  });

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  final DBHelper _dbHelper = DBHelper();
  List<WorkoutRoutine> _userRoutines = [];
  List<CustomExercise> _userExercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Load user's workout routines
      final routines = await _dbHelper.getWorkoutRoutinesByUser(widget.userId);
      
      // Load user's custom exercises
      final exercises = await _dbHelper.getCustomExercisesByUser(widget.userId);
      
      setState(() {
        _userRoutines = routines;
        _userExercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengesPage()),);},
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 6),
                  Text("mHealth", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()),);},
            ),
          ],
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  sectionTitle("Workout Routines"),
                  SizedBox(height: 8),
                  _buildRoutineGroup(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _userRoutines.isNotEmpty ? () {
                        // Navigate to view all routines page
                        _showAllRoutines();
                      } : null,
                      child: Text(
                        "View all >", 
                        style: TextStyle(
                          color: _userRoutines.isNotEmpty ? Colors.deepPurple : Colors.grey
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  sectionTitle("Your Exercises"),
                  SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     // Create Custom Exercise Button
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         onPressed: () {
                  //           // Navigate to custom exercise creation
                  //           NavigationHelper.navigateToCreateCustomExercise(context);
                  //         },
                  //         icon: const Icon(Icons.add_circle_outline, size: 20),
                  //         label: const Text('Create Custom Exercise'),
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: const Color(0xFF6B578C),
                  //           foregroundColor: Colors.white,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           minimumSize: const Size.fromHeight(44),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //   ],
                  // ),
                  // SizedBox(height: 12),
                  _buildCustomExercisesSection(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _userExercises.isNotEmpty ? () {
                        // Navigate to view all custom exercises page
                        _showAllCustomExercises();
                      } : null,
                      child: Text(
                        "View all >", 
                        style: TextStyle(
                          color: _userExercises.isNotEmpty ? Colors.deepPurple : Colors.grey
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  sectionTitle("Pre-Defined Exercises"),
                  SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2,
                    children: [
                      _buildExerciseButton("Arms", () {
                        Navigator.pushNamed(context, '/arms');
                      }),
                      _buildExerciseButton("Legs", () {
                        Navigator.pushNamed(context, '/legs');
                      }),
                      _buildExerciseButton("Shoulders", () {
                        Navigator.pushNamed(context, '/shoulders');
                      }),
                      _buildExerciseButton("Back", () {
                        Navigator.pushNamed(context, '/back');
                      }),
                      _buildExerciseButton("Abdomen", () {
                        Navigator.pushNamed(context, '/abdomen');
                      }),
                      _buildExerciseButton("Chest", () {
                        Navigator.pushNamed(context, '/chest');
                      }),
                      _buildExerciseButton("Stretches", () {
                        Navigator.pushNamed(context, '/stretches');
                      }),
                      _buildExerciseButton("Yoga", () {
                        Navigator.pushNamed(context, '/yoga');
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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

  Widget sectionTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _buildRoutineGroup() {
    if (_userRoutines.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.grey, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No workout routines yet. Create your first routine!',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show first 3 routines
    final displayRoutines = _userRoutines.take(3).toList();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: displayRoutines.asMap().entries.map((entry) {
          final index = entry.key;
          final routine = entry.value;
          
          return Column(
            children: [
              if (index > 0) Divider(height: 1, color: Colors.white),
              _buildInnerRoutineTile(routine),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInnerRoutineTile(WorkoutRoutine routine) {
    return InkWell(
      onTap: () => _viewRoutineDetails(routine),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.workoutRoutineName,
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Created ${_formatDate(routine.createdAt)}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomExercisesSection() {
    if (_userExercises.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: Colors.grey, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No custom exercises yet. Create your own exercises!',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show first 3 custom exercises
    final displayExercises = _userExercises.take(3).toList();
    
    return Column(
      children: displayExercises.map((exercise) => 
        _buildExerciseTile(exercise.exerciseName, exercise.targetArea, exercise)
      ).toList(),
    );
  }

  Widget _buildExerciseTile(String name, String category, [CustomExercise? exercise]) {
    return InkWell(
      onTap: exercise != null ? () => _viewExerciseDetails(exercise) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name, 
                style: TextStyle(color: Colors.black, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category, 
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }

  // Helper methods
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _viewRoutineDetails(WorkoutRoutine routine) {
    // Navigate to routine details page
    print('View routine: ${routine.workoutRoutineName}');
  }

  void _viewExerciseDetails(CustomExercise exercise) {
    // Navigate to exercise details page
    print('View exercise: ${exercise.exerciseName}');

  }

  void _showAllRoutines() {
    // Navigate to a page showing all user routines
    print('Show all routines for user: ${widget.userId}');
  }

  void _showAllCustomExercises() {
    // Navigate to a page showing all user custom exercises
    print('Show all custom exercises for user: ${widget.userId}');
  }
}