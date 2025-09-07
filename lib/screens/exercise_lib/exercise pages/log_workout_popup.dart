import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mhealthapp/db_helper.dart';
import 'log_workout_popup_2.dart';

class LogWorkoutPopup extends StatefulWidget {
  final int userId;
  
  const LogWorkoutPopup({
    super.key, 
    required this.userId
  });

  @override
  State<LogWorkoutPopup> createState() => _LogWorkoutPopupState();
}

class _LogWorkoutPopupState extends State<LogWorkoutPopup> {
  final TextEditingController durationController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> workoutRoutines = [];
  int? selectedRoutineId;
  String? selectedRoutineName;
  bool _isLoadingRoutines = true;

  @override
  void initState() {
    super.initState();
    _loadWorkoutRoutines();
  }

  Future<void> _loadWorkoutRoutines() async {
    try {
      final routines = await DBHelper().getRoutinesForDropdown(widget.userId);
      setState(() {
        workoutRoutines = routines;
        _isLoadingRoutines = false;
      });
    } catch (e) {
      setState(() => _isLoadingRoutines = false);
    }
  }

  bool _isValidSelection() {
    if (selectedRoutineId == null) return false;
    return workoutRoutines.any((routine) => routine['workout_routine_fact_id'] == selectedRoutineId);
  }

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

            // Routine Selection
            Text("Select Routine", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _isLoadingRoutines
              ? SizedBox(
                  height: 56,
                  child: Center(child: CircularProgressIndicator()),
                )
              : DropdownButtonFormField<int>(
                  value: _isValidSelection() ? selectedRoutineId : null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B578C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6B578C)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: Text("Choose a workout routine"),
                  items: workoutRoutines.map((routine) {
                    return DropdownMenuItem<int>(
                      value: routine['workout_routine_fact_id'],
                      child: Text(routine['workout_routine_name'] ?? 'Unnamed Routine'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRoutineId = value;
                      if (value != null) {
                        final routine = workoutRoutines.firstWhere(
                          (r) => r['workout_routine_fact_id'] == value,
                          orElse: () => {},
                        );
                        selectedRoutineName = routine['workout_routine_name'] ?? 'Unnamed Routine';
                      } else {
                        selectedRoutineName = null;
                      }
                    });
                  },
                ),
            SizedBox(height: 16),

            // Date Selection
            Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF6B578C)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                    Icon(Icons.calendar_today, color: Color(0xFF6B578C)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Duration Input
            Text("Duration (minutes)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: "min",
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

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndProceed,
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
  
  void _validateAndProceed() {
    if (selectedRoutineId == null || selectedRoutineName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a workout routine'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int? duration;
    if (durationController.text.trim().isNotEmpty) {
      duration = int.tryParse(durationController.text.trim());
      if (duration == null || duration <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid duration in minutes'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Create the workout log data to pass to the next popup
    final workoutData = {
      'userId': widget.userId,
      'workoutRoutineFactId': selectedRoutineId!,
      'routineName': selectedRoutineName!,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate),
      'durationMinutes': duration,
    };

    showDialog(
      context: context,
      builder: (_) => CaloriesBurnedPopup(workoutData: workoutData),
    ).then((result) {
      if (result == true) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    durationController.dispose();
    super.dispose();
  }
}