import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final void Function(String) onEmailChanged;

  const EmailInput({super.key, required this.onEmailChanged});

  @override
  EmailInputState createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  String? _email;

  // Characters/underscores/dots + @ + characters/underscores + dot + domain (2 to 4 letters)
  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
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
        if (value!.isEmpty || !_emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          _email = value;
        });
        widget.onEmailChanged(_email!);
      },
    );
  }
}
