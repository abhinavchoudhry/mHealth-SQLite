import 'package:flutter/material.dart';

import 'log_workout_popup_2.dart';

class LogWorkoutPopup extends StatefulWidget {
  const LogWorkoutPopup({super.key});

  @override
  State<LogWorkoutPopup> createState() => _LogWorkoutPopupState();
}

class _LogWorkoutPopupState extends State<LogWorkoutPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String period = "AM";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 8),
            Text("Name of Exercise", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Example",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6B578C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6B578C)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      hintText: "12:20",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B578C)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6B578C)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: period,
                  items: ['AM', 'PM'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (val) => setState(() => period = val!),
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => const CaloriesBurnedPopup(),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B578C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size.fromHeight(48),
                ),
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}