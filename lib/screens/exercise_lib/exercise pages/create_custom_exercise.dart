import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:mhealthapp/screens/ActivityStatus/activity_page.dart';
import 'package:mhealthapp/screens/Settings/settings_1.dart';
import 'package:mhealthapp/screens/challenges.dart';
import 'package:mhealthapp/screens/home_page.dart';
import 'package:mhealthapp/models/custom_exercise.dart';
import 'create_custom_exercise_popup1.dart';

class CreateCustomExercisePage extends StatefulWidget {
  final int userId;

  const CreateCustomExercisePage({super.key, required this.userId});

  @override
  State<CreateCustomExercisePage> createState() =>
      _CreateCustomExercisePageState();
}

class _CreateCustomExercisePageState extends State<CreateCustomExercisePage> {
  CustomExercise? exercise;
  final DBHelper _dbHelper = DBHelper();

  Future<void> _saveExercise(CustomExercise exercise) async {
    try {
      await _dbHelper.insertCustomExercise(exercise);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving exercise: $e')));
    }
  }

  void _startFlow() {
    final newExercise = CustomExercise(
      userDimId: widget.userId,
      dateCreated: DateTime.now().toIso8601String(),
      exerciseName: '',
      targetArea: [],
    );

    showDialog(
      context: context,
      builder:
          (_) => CreateCustomExercisePopup1(
            exercise: newExercise,
            onComplete: (created) async {
              setState(() {
                exercise = created;
              });
              await _saveExercise(created);
            },
          ),
    );
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
                  MaterialPageRoute(builder: (context) => ChallengesPage()),
                );
              },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              exercise == null
                  ? _buildBlankState()
                  : _buildExerciseDetails(exercise!),
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
            return;
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          }
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

  Widget _buildBlankState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create a Custom Exercise",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Create a custom exercise that is not already defined. "
          "Your created exercises can be accessed here or in the library.",
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _startFlow,
          child: const Text(
            "+ Create Custom Exercise",
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseDetails(CustomExercise e) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.exerciseName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Photo
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: e.hasPhoto ? Colors.grey.shade200 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                e.hasPhoto
                    ? (e.photoPath != null
                        ? Image.file(File(e.photoPath!), fit: BoxFit.cover)
                        : const Icon(Icons.image, color: Colors.grey, size: 60))
                    : const Center(child: Text("No photo")),
          ),
          const SizedBox(height: 16),

          if (e.warning != null && e.warning!.isNotEmpty)
            Text("⚠️ ${e.warning!}", style: const TextStyle(color: Colors.red)),

          const SizedBox(height: 12),
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(e.description ?? 'No description'),

          const SizedBox(height: 12),
          const Text(
            "Target Areas",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...e.targetArea.map((area) => Text("• $area")),

          if (e.equipment != null && e.equipment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              "Equipment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(e.equipment!),
          ],

          if (e.instructions != null && e.instructions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              "Instructions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(e.instructions!),
          ],
        ],
      ),
    );
  }
}
