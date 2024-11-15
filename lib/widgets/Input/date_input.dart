// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;

  const DateTimePicker({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
    this.initialDate,
    this.initialTime,
  });

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.now().add(const Duration(days: 1));
    selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

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
      final DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute
      );
      final DateTime currentDateTime = DateTime.now();

      if (selectedDateTime.isAfter(currentDateTime)) {
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
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Text(
            'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
            style: TextStyle(
              fontSize: 16,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Text(
            'Selected Time: ${selectedTime.format(context)}',
            style: TextStyle(
              fontSize: 16,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
