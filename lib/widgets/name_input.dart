import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  final void Function(String) onNameChanged;
  final String hintName;
  final String? initialValue;

  const NameInput({
    super.key,
    required this.onNameChanged,
    required this.hintName,
    this.initialValue,
  });

  @override
  NameInputState createState() => NameInputState();
}

class NameInputState extends State<NameInput> {
  String? _name;
  late TextEditingController _nameController;

  // Only alphabetical characters
  final RegExp _alphabeticalRegex = RegExp(
    r'^[a-zA-Z]+$',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: widget.hintName,
        border: InputBorder.none
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !_alphabeticalRegex.hasMatch(value)) {
          return 'Please enter a valid name.';
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
