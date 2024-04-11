import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
import 'package:sorttasks/widgets/inputs/string_input.dart';

class ProfileUserEditScreen extends StatefulWidget {
  const ProfileUserEditScreen({super.key});

  @override
  ProfileUserEditState createState() => ProfileUserEditState();
}

class ProfileUserEditState extends State<ProfileUserEditScreen> {
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
        child: const _PersonalEditForm(),
      ),
    );
  }
}

class _PersonalEditForm extends StatefulWidget {
  const _PersonalEditForm();

  @override
  _PersonalEditFormState createState() => _PersonalEditFormState();
}

class _PersonalEditFormState extends State<_PersonalEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? _firstName;
  late String? _lastName;
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
      Map<String, String>? userData = await FirestoreUtils.getUserData();

      if (userData != null) {
        setState(() {
          _firstName = userData['firstName'];
          _lastName = userData['lastName'];
          _dataIsLoading = false;
        });
      } else {
        setState(() {
          _noData = true;
        });
      }
    } catch (e) {
      setState(() {
        _noData = true;
      });
    }
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
                CircleAvatar(
                  radius: 85,
                  backgroundColor: isDarkTheme
                    ? const Color.fromRGBO(149, 149, 149, 1)
                    : const Color.fromRGBO(217, 217, 217, 1),
                  child: Icon(
                    Icons.person,
                    color: isDarkTheme ? Colors.white : Colors.black
                  ),
                ),
                const SizedBox(height: 50),
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
                                  Icons.badge,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: StringInput(onNameChanged: updateFirstName, hintName: "First Name", initialValue: _firstName),
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
                                  Icons.badge,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: StringInput(onNameChanged: updateLastName, hintName: "Last Name", initialValue: _lastName),
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
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: isDarkTheme
                      ? const Color.fromRGBO(0, 255, 0, 0.7)
                      : const Color.fromRGBO(0, 255, 0, 0.5),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          FirestoreUtils.updateUserDetails(context, _firstName!, _lastName!);
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
