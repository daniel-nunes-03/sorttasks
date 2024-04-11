// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/widgets/inputs/email_input.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
import 'package:sorttasks/widgets/validators/password_validator.dart';
import 'package:sorttasks/widgets/validators/repeated_password_validator.dart';

class ProfileAccountEditScreen extends StatefulWidget {
  const ProfileAccountEditScreen({super.key});

  @override
  ProfileAccountEditState createState() => ProfileAccountEditState();
}

class ProfileAccountEditState extends State<ProfileAccountEditScreen> {
  @override
  Widget build(BuildContext context) {
    if (SorttasksApp.loggedInUser == null) {
      // Use Future.delayed to schedule the logic after the build phase
      // This way the page won't crash during a reload (F5 or 'r' in the flutter terminal)
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });

      // Return an empty container while the navigation happens
      return const SizedBox.shrink();
    }

    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: isDarkTheme
          ? const Color.fromRGBO(45, 45, 45, 1)
          : Colors.white,
        child: const _AccountEditForm(),
      ),
    );
  }
}

class _AccountEditForm extends StatefulWidget {
  const _AccountEditForm();

  @override
  _AccountEditFormState createState() => _AccountEditFormState();
}

class _AccountEditFormState extends State<_AccountEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<RepeatPasswordValidatorState> repeatPasswordKey =
      GlobalKey<RepeatPasswordValidatorState>();
  final String _initialEmail = SorttasksApp.loggedInUser!.email!;
  String _email = SorttasksApp.loggedInUser!.email!;
  String _password = '';
  // ignore: unused_field
  String _repeatedPassword = '';

  void updateEmail(String email) {
    setState(() {
      _email = email;
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {                 
                  // Delete the currently logged-in user from Firestore
                  await FirestoreUtils.deleteUser(SorttasksApp.loggedInUser!.uid);

                  // Set the logged-in user to null and navigate to the login screen
                  SorttasksApp.loggedInUser = null;
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your account has been deleted successfully.'),
                      duration: Duration(seconds: 6),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There was an error deleting the user. Please try again or contact support.'),
                      duration: Duration(seconds: 8),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes, Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the delete confirmation dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
                const SizedBox(height: 50),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : const Color.fromRGBO(200, 200, 200, 1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                              Icons.email,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: EmailInput(onEmailChanged: updateEmail, initialValue: _email),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : const Color.fromRGBO(200, 200, 200, 1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                              Icons.password,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: PasswordValidator(onPasswordChanged: updatePassword),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : const Color.fromRGBO(200, 200, 200, 1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                              Icons.password,
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
                  ]
                ),
              ],
            )
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: isDarkTheme
                      ? Colors.black
                      : const Color.fromRGBO(217, 217, 217, 1),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/profile_view');
                      },
                      // Important to make it zero inside the button so it gets centered
                      // instead of inheriting the padding from the positioning of the avatar
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: isDarkTheme
                      ? Colors.red
                      : const Color.fromRGBO(255, 0, 0, 0.7),
                    child: TextButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      // Important to make it zero inside the button so it gets centered
                      // instead of inheriting the padding from the positioning of the avatar
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: isDarkTheme
                      ? const Color.fromRGBO(0, 255, 0, 0.7)
                      : const Color.fromRGBO(0, 255, 0, 0.5),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && repeatPasswordKey.currentState!.isPasswordMatch()) {
                          // If the form is valid, proceed with update user logic
                          _formKey.currentState!.save();
                          FirestoreUtils.updateUser(context, _email, _password, _initialEmail);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Changes have failed'),
                                content: const Text('The fields have been incorrectly filled or there has been an error. Please try again.'),
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
                      },
                      // Important to make it zero inside the button so it gets centered
                      // instead of inheriting the padding from the positioning of the avatar
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.check,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
