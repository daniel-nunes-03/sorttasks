// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/widgets/inputs/email_input.dart';
import 'package:sorttasks/widgets/inputs/string_input.dart';
import 'package:sorttasks/widgets/validators/password_validator.dart';
import 'package:sorttasks/widgets/validators/repeated_password_validator.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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
                padding: const EdgeInsets.all(20.0),
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
            const SizedBox(height: 50),
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
            const SizedBox(height: 70),
            Text(
              'Sign Up',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sort your tasks easily for free with Sorttasks!',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            _RegisterForm(
              onRegister: (email, firstName, lastName, password, context) {
                addUser(email, firstName, lastName, password, context);
              }
            ),
            const SizedBox(height: 50),
            Text(
              'Already have an account?',
              style: TextStyle(
                fontSize: 14,
                color: isDarkTheme ? Colors.white : Colors.black,
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Go to login screen logic
                  Navigator.pushReplacementNamed(context, '/login');
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
                      'SIGN IN',
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
                        Icons.login,
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

  void addUser(String email, String firstName, String lastName, String password, BuildContext context) async {
    try {     
      // Check if the email is available
      bool isEmailAvailable = await FirestoreUtils.checkEmailAvailable(email, password);

      if (!isEmailAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is already in use. Please choose a different one.'),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      // Both username and email are available, proceed to add user
      await FirestoreUtils.addUser(email, firstName, lastName, password);

      // If registration is successful, show a successful registration popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('Your account has been created successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog and navigate to the login screen
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Proceed'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is already in use. Please choose a different one.'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error registering user. Try again or contact the support.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }
}


class _RegisterForm extends StatefulWidget {
  final Function(String, String, String, String, BuildContext) onRegister;

  const _RegisterForm({
    required this.onRegister,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RepeatPasswordValidatorState> repeatPasswordKey =
      GlobalKey<RepeatPasswordValidatorState>();
  late String _email = '';
  late String _firstName = '';
  late String _lastName = '';
  late String _password = '';
  // ignore: unused_field
  late String _repeatedPassword = '';

  void updateEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void updateFirstName(String firstName) {
    setState(() {
      _firstName = firstName;
    });
  }

  void updateLastName(String lastName) {
    setState(() {
      _lastName = lastName;
    });
  }

  void updatePassword(String password) {
    setState(() {
      _password = password;
      repeatPasswordKey.currentState?.updatePassword(password);
    });
  }

  void updateRepeatedPassword(String repeatedPassword) {
    setState(() {
      _repeatedPassword = repeatedPassword;
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Container(
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
                              child: EmailInput(onEmailChanged: updateEmail)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Container(
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
                                Icons.badge,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: StringInput(onNameChanged: updateFirstName, hintName: 'First Name',)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Container(
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
                                Icons.badge,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: StringInput(onNameChanged: updateLastName, hintName: 'Last Name',)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Container(
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
                              child: PasswordValidator(onPasswordChanged: updatePassword)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Container(
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
                              child: RepeatPasswordValidator(
                                key: repeatPasswordKey,
                                onRepeatPasswordChanged: updateRepeatedPassword,
                                password: _password,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && repeatPasswordKey.currentState!.isPasswordMatch()) {
                        // If the form is valid, proceed with registration logic
                        _formKey.currentState!.save();
                        widget.onRegister(_email, _firstName, _lastName, _password, context);
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
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 22,
                            color: isDarkTheme ? Colors.white : Colors.black,
                          )
                        ),
                        const SizedBox(width: 15),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
