// import 'package:flutter/material.dart';
// import 'package:mhealthapp/screens/exercise_lib/exercise%20pages/custom_exercise_model.dart';
// import 'create_custom_exercise_popup3.dart';

// class CreateCustomExercisePopup2 extends StatefulWidget {
//   final ExerciseModel exercise;
//   final Function(ExerciseModel) onComplete;

//   const CreateCustomExercisePopup2({
//     super.key,
//     required this.exercise,
//     required this.onComplete,
//   });

//   @override
//   State<CreateCustomExercisePopup2> createState() =>
//       _CreateCustomExercisePopup2State();
// }

// class _CreateCustomExercisePopup2State
//     extends State<CreateCustomExercisePopup2> {
//   final List<String> equipment = [];

//   Future<void> _addEquipment() async {
//     final controller = TextEditingController();
//     final result = await showDialog<String>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Add Equipment"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "Enter equipment name"),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           TextButton(
//               onPressed: () => Navigator.pop(context, controller.text),
//               child: const Text("Add")),
//         ],
//       ),
//     );
//     if (result != null && result.isNotEmpty) {
//       setState(() => equipment.add(result));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Close button
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pop(),
//                 child: const Icon(Icons.close, color: Colors.black, size: 24),
//               ),
//             ),
//             const SizedBox(height: 8),

//             // Title
//             const Text(
//               "Exercise Equipment",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),

//             // List of added equipment
//             ...equipment.map((e) => Padding(
//                   padding: const EdgeInsets.only(bottom: 4),
//                   child: Text("• $e",
//                       style: const TextStyle(
//                           fontSize: 15, color: Colors.black87)),
//                 )),

//             const SizedBox(height: 8),

//             // + Add Equipment link
//             GestureDetector(
//               onTap: _addEquipment,
//               child: const Text(
//                 "+ Add Equipment",
//                 style: TextStyle(
//                   color: Colors.deepPurple,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Next button
//             SizedBox(
//               width: double.infinity,
//               height: 44,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 onPressed: () {
//                   final updated =
//                       widget.exercise.copyWith(equipment: equipment);
//                   Navigator.pop(context);
//                   showDialog(
//                     context: context,
//                     builder: (_) => CreateCustomExercisePopup3(
//                       exercise: updated,
//                       onComplete: widget.onComplete,
//                     ),
//                   );
//                 },
//                 child: const Text("Next", style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mhealthapp/models/custom_exercise.dart';
import 'create_custom_exercise_popup3.dart';

class CreateCustomExercisePopup2 extends StatefulWidget {
  final CustomExercise exercise;
  final Function(CustomExercise) onComplete;

  const CreateCustomExercisePopup2({
    super.key,
    required this.exercise,
    required this.onComplete,
  });

  @override
  State<CreateCustomExercisePopup2> createState() =>
      _CreateCustomExercisePopup2State();
}

class _CreateCustomExercisePopup2State
    extends State<CreateCustomExercisePopup2> {
  final List<String> equipment = [];

  Future<void> _addEquipment() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 80,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title + close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Equipment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Input field
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter equipment name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                            () =>
                                Navigator.pop(context, controller.text.trim()),
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => equipment.add(result));
    }
  }

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
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.black, size: 24),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            const Text(
              "Exercise Equipment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // List of added equipment
            ...equipment.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $e",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // + Add Equipment link
            GestureDetector(
              onTap: _addEquipment,
              child: const Text(
                "+ Add Equipment",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Next button
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
                  final updated = widget.exercise.copyWith(
                    equipment: equipment.join(', '),
                  );
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder:
                        (_) => CreateCustomExercisePopup3(
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
