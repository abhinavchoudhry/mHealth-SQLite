// import 'package:exercises_pages/exercise_routine_ai.dart';
import 'loading_plan_popup.dart';
import 'package:flutter/material.dart';

class AdditionalCommentsPopup extends StatefulWidget {
  const AdditionalCommentsPopup({super.key});

  @override
  State<AdditionalCommentsPopup> createState() => _AdditionalCommentsPopupState();
}

class _AdditionalCommentsPopupState extends State<AdditionalCommentsPopup> {
  final TextEditingController _commentsController = TextEditingController();

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
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 28),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Additional Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Feel free to include below anything else we should know to best tailor your routine!',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextField(
                  controller: _commentsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter here',
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
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, bottom: 8),
                  child: Icon(Icons.mic, color: Color(0xFF6B578C), size: 20),
                )
              ],
            ),

            const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
              Navigator.pop(context); // Close AdditionalCommentsPopup first

              // Show loading dialog; it will handle navigation itself
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const LoadingDialog(),
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
    );
  }
}


