import 'package:flutter/material.dart';
import 'package:mhealthapp/models/custom_exercise.dart';

class CreateCustomExercisePopup4 extends StatefulWidget {
  final CustomExercise exercise;
  final Function(CustomExercise) onComplete;

  const CreateCustomExercisePopup4({
    super.key,
    required this.exercise,
    required this.onComplete,
  });

  @override
  State<CreateCustomExercisePopup4> createState() =>
      _CreateCustomExercisePopup4State();
}

class _CreateCustomExercisePopup4State
    extends State<CreateCustomExercisePopup4> {
  final List<String> warnings = [];
  String? photo;

  // Custom dialog to add warning
  Future<void> _addWarning() async {
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
                        "Add Warning",
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
                      hintText: "Enter warning",
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
      setState(() => warnings.add(result));
    }
  }

  // Custom dialog to choose photo source
  Future<void> _pickPhoto() async {
    final result = await showDialog<String>(
      context: context,
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
                children: [
                  const Text(
                    "Upload Photo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: Colors.deepPurple,
                    ),
                    title: const Text("Choose from Gallery"),
                    onTap: () => Navigator.pop(context, "gallery_path.png"),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                      color: Colors.deepPurple,
                    ),
                    title: const Text("Take a Photo"),
                    onTap: () => Navigator.pop(context, "camera_path.png"),
                  ),
                ],
              ),
            ),
          ),
    );

    if (result != null) {
      setState(() => photo = result);
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
              "Upload Photo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),

            // Upload area
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child:
                      photo == null
                          ? const Text(
                            "Tap to add a photo",
                            style: TextStyle(color: Colors.black54),
                          )
                          : const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.deepPurple,
                          ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Warnings
            const Text(
              "Add Warning",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...warnings.map(
              (w) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "⚠️ $w",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // + Add Warning link
            GestureDetector(
              onTap: _addWarning,
              child: const Text(
                "+ Add Warning",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Done button
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
                    warning: warnings.join('; '),
                    photoPath: photo,
                  );
                  widget.onComplete(updated);
                  Navigator.of(context).pop(updated);
                },
                child: const Text("Done", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
