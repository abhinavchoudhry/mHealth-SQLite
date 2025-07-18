

import 'package:flutter/material.dart';

import 'log_activity.dart';

class CaloriesBurnedPopup extends StatefulWidget {
  const CaloriesBurnedPopup({super.key});

  @override
  State<CaloriesBurnedPopup> createState() => _CaloriesBurnedPopupState();
}

class _CaloriesBurnedPopupState extends State<CaloriesBurnedPopup> {
  final TextEditingController caloriesController = TextEditingController();

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
                icon: const Icon(Icons.close, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calories Burned',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter a value',
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
                const SizedBox(width: 8),
                const Text('cal', style: TextStyle(color: Color(0xFF6B578C))),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Note: This field is optional, but recommended to provide optimal health insights. Use a digital watch to record this information in conjunction with this app.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);  // Pop all popups
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LogActivityPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B578C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size.fromHeight(48),
                ),
                child: Text("Done"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}