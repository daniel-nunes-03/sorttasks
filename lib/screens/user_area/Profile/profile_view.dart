// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileViewScreen> {
  late String? _firstName;
  late String? _lastName;
  late Timestamp? _creationDate;
  late int? _createdTasks;
  late int? _completedTasks;
  late String _profileImageUrl = '';
  bool _dataIsLoading = true;
  bool _noData = false;

  @override
  void initState() {
    super.initState();
    // Initialization of the temporary values
    _loadAuthenticatedUserData();
  }

  Future<void> _loadAuthenticatedUserData() async {
    try {
      Map<String, dynamic>? userData = await FirestoreUtils.getUserData();

      if (userData != null) {
        setState(() {
          _firstName = userData['firstName'];
          _lastName = userData['lastName'];
          _creationDate = userData['creationDate'];
          _createdTasks = userData['createdTasks'];
          _completedTasks = userData['completedTasks'];
          _profileImageUrl = userData['profileImageUrl'];
          _dataIsLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _noData = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _noData = true;
        });
      }
    }
  }

  void _showPasswordConfirmationDialog(BuildContext context, {required bool navigateToCredentialChangeScreen}) async {
    String enteredPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                onChanged: (value) {
                  enteredPassword = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your password',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                NavigatorState navigator = Navigator.of(context);
                try {
                  // Validate the entered password using Firebase authentication
                  bool isPasswordCorrect = await FirestoreUtils.verifyPassword(enteredPassword);

                  navigator.pop(); // Close the password confirmation dialog

                  if (isPasswordCorrect) {
                    if (navigateToCredentialChangeScreen) {
                      bool isEmailVerified = await FirestoreUtils.checkEmailVerification();
                      
                      if (isEmailVerified) {
                        navigator.pushReplacementNamed('/profile_account_edit');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email is not verified. Please verify your email before proceeding.'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    } else {
                      navigator.pushReplacementNamed('/profile_personal_edit');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The inserted password is not valid.'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                } catch (error) {
                  // Close dialog and navigate back
                  navigator.pop();
                  navigator.pushReplacementNamed('/profile_view');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error verifying password. Please try again.'),
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the password confirmation dialog
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
    final scrollController = ScrollController();
    
    return Scaffold(
      backgroundColor: isDarkTheme
        ? const Color.fromRGBO(45, 45, 45, 1)
        : Colors.white,
      appBar: const CustomAppBar(),
      body: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    _profileImageUrl != ''
                    ? CircleAvatar(
                        radius: 85,
                        backgroundImage: NetworkImage(_profileImageUrl),
                      )
                    : CircleAvatar(
                        radius: 85,
                        backgroundColor: isDarkTheme
                          ? const Color.fromRGBO(149, 149, 149, 1)
                          : const Color.fromRGBO(217, 217, 217, 1),
                        child: Icon(
                          Icons.person,
                          color: isDarkTheme ? Colors.white : Colors.black
                        ),
                      ),
                    const SizedBox(height: 40),
                    _dataIsLoading // Conditional rendering based on flags
                      ? _noData
                        ? const Text(
                            'Error: An error occurred while retrieving your data.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )
                        : const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              _firstName!,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _lastName!,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                    const SizedBox(height: 75),
                    SizedBox(
                      width: 280,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          _showPasswordConfirmationDialog(context, navigateToCredentialChangeScreen: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 102, 255, 0.4) : const Color.fromRGBO(255, 168, 0, 0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              size: 24
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Edit personal data',
                              style: TextStyle(
                                fontSize: 22,
                                color: isDarkTheme ? Colors.white : Colors.black,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 330,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          _showPasswordConfirmationDialog(context, navigateToCredentialChangeScreen: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 102, 255, 0.4) : const Color.fromRGBO(255, 168, 0, 0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              size: 24
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Edit account credentials',
                              style: TextStyle(
                                fontSize: 22,
                                color: isDarkTheme ? Colors.white : Colors.black,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 75),
                    _dataIsLoading // Conditional rendering based on flags
                      ? _noData
                        ? const Text(
                            'Error: An error occurred while retrieving your data.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )
                        : const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              'Joined in: ${DateFormat.yMMMd().add_jms().format(_creationDate!.toDate())}',
                              style: TextStyle(
                                fontSize: 15,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Tasks created: $_createdTasks',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Tasks completed: $_completedTasks',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: isDarkTheme
          ? const Color.fromRGBO(45, 45, 45, 1)
          : Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: isDarkTheme
                  ? Colors.black
                  : const Color.fromRGBO(217, 217, 217, 1),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main_screen');
                  },
                  // Important to make it zero inside the button so it gets centered
                  // instead of inheriting the padding from the positioning of the avatar
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: isDarkTheme
                  ? const Color.fromRGBO(255, 0, 0, 0.7)
                  : Colors.red,
                child: TextButton(
                  onPressed: () {
                    SorttasksApp.loggedInUser = null;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  // Important to make it zero inside the button so it gets centered
                  // instead of inheriting the padding from the positioning of the avatar
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
