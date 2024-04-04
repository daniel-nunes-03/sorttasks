import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  final void Function(String) onNameChanged;

  const NameInput({super.key, required this.onNameChanged});

  @override
  NameInputState createState() => NameInputState();
}

class NameInputState extends State<NameInput> {
  String? _name;

  // Only alphabetical characters
  final RegExp _alphabeticalRegex = RegExp(
    r'^[a-zA-Z]+$',
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Email',
        border: InputBorder.none
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !_alphabeticalRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _name = value;
        });
        widget.onNameChanged(_name!);
      },
    );
  }
}
