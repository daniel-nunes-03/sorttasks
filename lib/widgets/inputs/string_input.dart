import 'package:flutter/material.dart';

class StringInput extends StatefulWidget {
  final void Function(String) onNameChanged;
  final String hintName;
  final String? initialValue;
  final int? maximumLength;
  final bool multipleLines;
  final bool noRegex;

  const StringInput({
    super.key,
    required this.onNameChanged,
    required this.hintName,
    this.initialValue,
    this.maximumLength,
    this.multipleLines = false,
    this.noRegex = false,
  });

  @override
  NameInputState createState() => NameInputState();
}

class NameInputState extends State<StringInput> {
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
      maxLength: widget.multipleLines ? 5000 : widget.maximumLength,
      maxLines: widget.multipleLines ? null : 1,
      textInputAction: widget.multipleLines ? TextInputAction.newline : TextInputAction.done,
      decoration: InputDecoration(
        hintText: widget.hintName,
        border: InputBorder.none
      ),
      keyboardType: widget.multipleLines ? TextInputType.multiline : TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field cannot be empty.';
        } else if (!widget.noRegex && !_alphabeticalRegex.hasMatch(value)) {
          return 'Only alphabetical characters are allowed.';
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
