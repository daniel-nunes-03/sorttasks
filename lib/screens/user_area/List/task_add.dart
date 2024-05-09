// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
import 'package:sorttasks/widgets/inputs/date_input.dart';
import 'package:sorttasks/widgets/inputs/string_input.dart';
import 'package:sorttasks/widgets/inputs/number_input.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  TaskAddState createState() => TaskAddState();
}

class TaskAddState extends State<TaskAddScreen> {
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
        child: const _TaskAddForm(),
      ),
    );
  }
}

class _TaskAddForm extends StatefulWidget {
  const _TaskAddForm();

  @override
  _TaskAddFormState createState() => _TaskAddFormState();
}

class _TaskAddFormState extends State<_TaskAddForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  String? _title;
  DateTime? _finalDate;
  TimeOfDay? _finalTime;
  int? _taskPriority;
  final bool _taskStatus = false; // not completed
  String? _description;

  void updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void updateFinalDate(DateTime finalDate) {
    setState(() {
      _finalDate = finalDate;
    });
  }

  void updateFinalTime(TimeOfDay finalTime) {
    setState(() {
      _finalTime = finalTime;
    });
  }

  void updateTaskPriority(int taskPriority) {
    setState(() {
      _taskPriority = taskPriority;
    });
  }

  void updateDescription(String description) {
    setState(() {
      _description = description;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                                  Icons.title,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: StringInput(
                                  onNameChanged: updateTitle,
                                  hintName: "Title",
                                  maximumLength: 14,
                                  noRegex: true
                                ),
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
                                  Icons.date_range,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: DateTimePicker(
                                  onDateSelected: updateFinalDate,
                                  onTimeSelected: (TimeOfDay time) {
                                    updateFinalTime(time);
                                  },
                                ),
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
                                  Icons.priority_high,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: NumberInput(
                                  onNumberChanged: updateTaskPriority,
                                  hintName: "Task Priority"
                                ),
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
                                  Icons.description,
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: StringInput(
                                  onNameChanged: updateDescription,
                                  hintName: "Description",
                                  multipleLines: true,
                                  noRegex: true
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
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
                    Icons.arrow_back,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: isDarkTheme
                  ? const Color.fromRGBO(0, 255, 0, 0.7)
                  : const Color.fromRGBO(0, 255, 0, 0.5),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await FirestoreUtils.createTask(
                        context,
                        _title!,
                        _finalDate!,
                        _finalTime!,
                        _taskPriority!,
                        _taskStatus,
                        _description!
                      );
                      Navigator.pushReplacementNamed(context, '/main_screen');
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Task creation has failed'),
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
            ],
          ),
        ),
      ],
    );
  }
}
