import 'package:flutter/material.dart';
import 'dart:async';
import 'exercise_routine_ai.dart'; 

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.05;
      });

      if (_progress >= 1.0) {
        _timer?.cancel();
        Navigator.pop(context); // close dialog itself
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExerciseRoutinePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Generating a Workout Plan...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.black12,
              color: const Color(0xFF6B578C),
            ),
            const SizedBox(height: 12),
            Text('${(_progress * 100).toInt()}%'),
          ],
        ),
      ),
    );
  }
}
