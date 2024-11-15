import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class NumberInput extends StatefulWidget {
  final void Function(int) onNumberChanged;
  final String? hintName;
  final int? initialValue;

  const NumberInput({
    super.key,
    required this.onNumberChanged,
    this.hintName,
    this.initialValue,
  });

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  String? _number;

  // Only numerical characters between 1 and 5
  final RegExp _numericRegex = RegExp(
    r'^[1-5]$',
  );

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return TextFormField(
      initialValue: widget.initialValue == null ? '' : '${widget.initialValue}',
      maxLength: 1,
      decoration: InputDecoration(
        hintText: widget.hintName,
        hintStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        border: InputBorder.none,
        counterStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        )
      ),
      style: TextStyle(
        color: isDarkTheme ? Colors.white : Colors.black,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty || !_numericRegex.hasMatch(value)) {
          return 'Please enter a number from 1 to 5.';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _number = value;
        });
        widget.onNumberChanged(int.parse(_number!));
      },
    );
  }
}
