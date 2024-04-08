import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final void Function(String) onEmailChanged;
  final String? initialValue;

  const EmailInput({
    super.key,
    required this.onEmailChanged,
    this.initialValue,
  });

  @override
  EmailInputState createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  String? _email;
  late TextEditingController _emailController;

  // Characters/underscores/dots + @ + characters/underscores + dot + domain (2 to 4 letters)
  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: InputBorder.none
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !_emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address.';
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
