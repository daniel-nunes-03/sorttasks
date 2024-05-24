import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

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
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
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
