// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const SizedBox.shrink();
    }

    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
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
  late String _profileImageUrl = '';
  bool _dataIsLoading = true;
  bool _noData = false;
  final ScrollController _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAuthenticatedUserData();
  }

  Future<void> _loadAuthenticatedUserData() async {
    try {
      Map<String, dynamic>? userData = await FirestoreUtils.getUserData();
      if (userData != null) {
        setState(() {
          _firstName = userData['firstName'];
          _lastName = userData['lastName'];
          _profileImageUrl = userData['profileImageUrl'];
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

  void _uploadNewProfileImage(String userId, {required bool isRemove}) async {
    if (isRemove) {
      await FirestoreUtils.removeImage(userId);
      setState(() {
        _profileImageUrl = '';
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Image Removed'),
            content: const Text('Your profile image has been successfully removed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String? imageUrl = await FirestoreUtils.uploadImage(imageFile, userId);
        if (imageUrl != null) {
          setState(() {
            _profileImageUrl = imageUrl;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Image Upload Failed'),
                content: const Text('Failed to upload your profile image.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Scaffold(
      backgroundColor: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollcontroller,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollcontroller,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 180,
                            child: _profileImageUrl != ''
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
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _uploadNewProfileImage(SorttasksApp.loggedInUser!.uid, isRemove: true),
                            child: const Text('Remove Profile Image'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _uploadNewProfileImage(SorttasksApp.loggedInUser!.uid, isRemove: false),
                            child: const Text('Upload New Profile Image'),
                          ),
                          const SizedBox(height: 20),
                          _dataIsLoading
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          CircleAvatar(
                            backgroundColor: isDarkTheme ? Colors.black : const Color.fromRGBO(217, 217, 217, 1),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/profile_view');
                              },
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
                          // Save button
                          CircleAvatar(
                            backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 255, 0, 0.7) : const Color.fromRGBO(0, 255, 0, 0.5),
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
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
