import 'gen_AI_workout_3.dart';

import 'package:flutter/material.dart';

class UserGoalsPopup extends StatefulWidget {
  const UserGoalsPopup({super.key});

  @override
  State<UserGoalsPopup> createState() => _UserGoalsPopupState();
}

class _UserGoalsPopupState extends State<UserGoalsPopup> {
  final List<String> selectedGoals = [];
  final List<String> allGoals = [
    'Weight Loss', 'Muscle Gain', 'Cardiovascular Fitness', 'Functional Fitness',
  ];

  String? selectedFitnessLevel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 28),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Exercise Goal(s):',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

             
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: allGoals.map((goal) {
                  return SizedBox(
                    width: 140,
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedGoals.contains(goal),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedGoals.add(goal);
                              } else {
                                selectedGoals.remove(goal);
                              }
                            });
                          },
                          activeColor: const Color(0xFF6B578C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(child: Text(goal)),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              /// Add custom goal link
              GestureDetector(
                onTap: () {
                  // Add custom goal logic
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    '+ Add Custom Goal',
                    style: TextStyle(
                      color: Color(0xFF6B578C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Preexisting Health Condition(s)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add any preexisting health conditions not already recorded in app.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text(
                '(e.g., arthritis, heart conditions, joint pain, past injuries, etc.)',
                style: TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  // condition logic
                },
                child: const Text(
                  '+ Add Preexisting Health Condition',
                  style: TextStyle(
                    color: Color(0xFF6B578C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Current Fitness Level',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              /// Fitness level radio buttons
              ...['Beginner', 'Intermediate', 'Expert'].map((level) {
                return RadioListTile<String>(
                  value: level,
                  groupValue: selectedFitnessLevel,
                  onChanged: (value) {
                    setState(() {
                      selectedFitnessLevel = value;
                    });
                  },
                  title: Text(level),
                  activeColor: const Color(0xFF6B578C),
                  contentPadding: EdgeInsets.zero,
                );
              }),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close current popup first

                    // open the new one
                    showDialog(
                      context: context,
                      builder: (context) => const AdditionalCommentsPopup(),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B578C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
