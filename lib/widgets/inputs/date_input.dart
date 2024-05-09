// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  const DateTimePicker({super.key, required this.onDateSelected, required this.onTimeSelected});

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      // Call the callback function to update the date in the parent widget
      widget.onDateSelected(selectedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTime != null) {
      final DateTime selectedDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, pickedTime.hour, pickedTime.minute);
      final DateTime currentDateTime = DateTime.now();

      if (selectedDateTime.isAfter(currentDateTime) ||
          (selectedDateTime.day != currentDateTime.day && selectedDateTime.hour != currentDateTime.hour)) {
        setState(() {
          selectedTime = pickedTime;
        });
        // Call the callback function to update the time in the parent widget
        widget.onTimeSelected(selectedTime);
      } else {
        // Show error message or handle invalid selection
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a time after the current time, or a different day.'),
        ));
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Text(
            'Selected Date: ${selectedDate.toString()}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Text(
            'Selected Time: ${selectedTime.format(context)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
