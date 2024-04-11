import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final void Function(String) onPasswordChanged;

  const PasswordInput({super.key, required this.onPasswordChanged});

  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  String? _password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Password',
        border: InputBorder.none,
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a valid password.';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _password = value;
        });
        widget.onPasswordChanged(_password!);
      },
    );
  }
}
