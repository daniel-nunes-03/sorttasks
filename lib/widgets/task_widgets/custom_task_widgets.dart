import 'package:flutter/material.dart';

class TaskDetailItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool isCheckbox;
  final bool isChecked;

  const TaskDetailItem({
    super.key,
    required this.label,
    this.value,
    this.isCheckbox = false,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCheckbox ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 26, color: Colors.white),
        ),
        Container(
          color: const Color.fromARGB(255, 215, 215, 215),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isCheckbox
                ? Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {},
                  )
                : Text(
                    value!,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
          ),
        ),
      ],
    );
  }
}
