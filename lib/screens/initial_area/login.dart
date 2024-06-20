// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/widgets/Input/email_input.dart';
import 'package:sorttasks/widgets/Input/password_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkTheme ? Colors.black : Colors.white,
                  ),
                  child: Icon(
                    isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sorttasks',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.task,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),
            Text(
              'Welcome!',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please sign in to continue',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            const _LoginForm(),
            const SizedBox(height: 50),
            Text(
              'Forgot your password?',
              style: TextStyle(
                fontSize: 14,
                color: isDarkTheme ? Colors.white : Colors.black,
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 190,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  String email = '';
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Recover Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter your email',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (email.isNotEmpty && EmailInputState().emailRegex.hasMatch(email)) {
                                // Send password reset email and close the dialog
                                await FirestoreUtils.sendPasswordResetEmail(context, email);
                              } else {
                                // Show an alert if the entered email is invalid
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Invalid Email'),
                                      content: const Text('Please enter a valid email address.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkTheme ? const Color.fromRGBO(255, 80, 80, 0.8) : const Color.fromRGBO(255, 198, 198, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recover it here',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_center,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 40,
                      ),
                    ),
                  ],
                ),                
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'No account? Register here:',
              style: TextStyle(
                fontSize: 14,
                color: isDarkTheme ? Colors.white : Colors.black,
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Go to register page logic
                  Navigator.pushReplacementNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkTheme ? const Color.fromRGBO(255, 155, 63, 0.8) : const Color.fromRGBO(255, 155, 63, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 22,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      )
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.app_registration,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 40,
                      ),
                    ),
                  ],
                )                
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email = '';
  late String _password = '';
  bool _rememberMe = false;

  void updateEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void updatePassword(String password) {
    setState(() {
      _password = password;
    });
  }

  Future<void> _saveLoginState(bool isRemembered) async {
    final prefs = await SharedPreferences.getInstance();
    if (isRemembered) {
      await prefs.setString('sorttasks_email', _email);
      await prefs.setString('sorttasks_password', _password);
    } else {
      await prefs.remove('sorttasks_email');
      await prefs.remove('sorttasks_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: EmailInput(onEmailChanged: updateEmail),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.key,
                          color: isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: PasswordInput(onPasswordChanged: updatePassword),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text(
                      'Remember Me',
                      style: TextStyle(
                        color: isDarkTheme ? Colors.white : Colors.black
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 180,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Check if the email and password combination exists by awaiting the Future<bool>
                bool loginSuccessful = await FirestoreUtils.login(_email, _password);

                if (loginSuccessful) {
                  // Save login state
                  await _saveLoginState(_rememberMe);
                  Navigator.pushReplacementNamed(context, '/main_screen');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('The provided email or password is incorrect'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('Proceed'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 56, 255, 0.6) : const Color.fromRGBO(0, 56, 255, 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 22,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.login,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
