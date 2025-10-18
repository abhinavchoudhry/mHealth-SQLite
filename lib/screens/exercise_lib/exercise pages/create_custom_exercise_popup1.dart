import 'package:flutter/material.dart';
import 'package:mhealthapp/models/custom_exercise.dart';
import 'create_custom_exercise_popup2.dart';

class CreateCustomExercisePopup1 extends StatefulWidget {
  final CustomExercise exercise;
  final Function(CustomExercise) onComplete;

  const CreateCustomExercisePopup1({
    super.key,
    required this.exercise,
    required this.onComplete,
  });

  @override
  State<CreateCustomExercisePopup1> createState() =>
      _CreateCustomExercisePopup1State();
}

class _CreateCustomExercisePopup1State
    extends State<CreateCustomExercisePopup1> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final Map<String, bool> bodyParts = {
    "Arms": false,
    "Back": false,
    "Legs": false,
    "Shoulders": false,
    "Abdomen": false,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.black, size: 24),
              ),
            ),
            const SizedBox(height: 8),

            // Name of Exercise
            const Text(
              "Name of Exercise",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter a value",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Target Areas
            const Text(
              "Target Area(s) of Body:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 30,
              runSpacing: 12,
              children:
                  bodyParts.keys.map((part) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: bodyParts[part],
                          onChanged: (val) {
                            setState(() {
                              bodyParts[part] = val ?? false;
                            });
                          },
                          activeColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                        Text(part),
                      ],
                    );
                  }).toList(),
            ),

            const SizedBox(height: 10),

            // Description
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Type here...",
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  final selectedParts =
                      bodyParts.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();

                  final updated = widget.exercise.copyWith(
                    exerciseName: nameController.text,
                    description: descController.text,
                    targetArea: selectedParts,
                  );

                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder:
                        (_) => CreateCustomExercisePopup2(
                          exercise: updated,
                          onComplete: widget.onComplete,
                        ),
                  );
                },
                child: const Text("Next", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
