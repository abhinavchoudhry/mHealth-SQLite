import '../../home_page.dart';
import 'gen_AI_workout_2.dart';
import 'package:flutter/material.dart';

class GenerateAIRoutinePopup extends StatefulWidget {
  const GenerateAIRoutinePopup({super.key});

  @override
  State<GenerateAIRoutinePopup> createState() => _GenerateAIRoutinePopupState();
}


class _GenerateAIRoutinePopupState extends State<GenerateAIRoutinePopup> {
  final List<String> selectedAreas = [];
  final TextEditingController durationController = TextEditingController();
  String? selectedIntensity;

  final List<String> areas = [
    "Arms", "Back", "Legs", "Shoulders", "Abdomen", "Full Body"
  ];

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
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 28),
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                'Target Area(s):',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 4.5,
                children: areas.map((area) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: selectedAreas.contains(area),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedAreas.add(area);
                            } else {
                              selectedAreas.remove(area);
                            }
                          });
                        },
                        activeColor: const Color(0xFF6B578C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text(area),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              const Text(
                'Workout Duration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter a value',
                    hintStyle: const TextStyle(
                        color: Color(0xFF6B578C), fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF6B578C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF6B578C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '*enter number in minutes',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 24),
              const Text(
                'Exercise Intensity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              ...['Light', 'Moderate', 'Intense'].map((level) {
                return RadioListTile<String>(
                  title: Text(level),
                  value: level,
                  groupValue: selectedIntensity,
                  activeColor: const Color(0xFF6B578C),
                  onChanged: (value) {
                    setState(() {
                      selectedIntensity = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close current popup first

                    // Then open the new one
                    showDialog(
                      context: context,
                      builder: (context) => const UserGoalsPopup(),
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
