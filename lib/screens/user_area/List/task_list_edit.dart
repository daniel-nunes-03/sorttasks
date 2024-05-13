// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/List/task_list_details.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
import 'package:sorttasks/widgets/inputs/date_input.dart';
import 'package:sorttasks/widgets/inputs/number_input.dart';
import 'package:sorttasks/widgets/inputs/string_input.dart';

class TaskEditScreen extends StatefulWidget {
  final Task task;

  const TaskEditScreen({super.key, required this.task});

  @override
  TaskEditState createState() => TaskEditState();
}

class TaskEditState extends State<TaskEditScreen> {
  late Task currentTask;
  bool _dataIsLoading = true;
  bool _noData = false;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch the latest event data
      Task latestTaskData = await FirestoreUtils.getTaskDetails(currentTask.id);

      setState(() {
        currentTask = latestTaskData;
        _dataIsLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an error getting the task details. Please try again or contact support.'),
          duration: Duration(seconds: 5),
        ),
      );
      setState(() {
        _noData = true;
      });
    }
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

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: isDarkTheme
        ? const Color.fromRGBO(45, 45, 45, 1)
        : Colors.white,
      body: _dataIsLoading // Conditional rendering based on flags
        ? _noData
          ? const Text(
              'Error: An error occurred while retrieving your data.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            )
          : const CircularProgressIndicator()
        : _TaskEditForm(currentTask: currentTask),
    );
  }
}

class _TaskEditForm extends StatefulWidget {
  final Task currentTask;

  const _TaskEditForm({required this.currentTask});

  @override
  _TaskEditFormState createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<_TaskEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _title = widget.currentTask.title;

  late DateTime _finalDate =  DateTime(
    widget.currentTask.finishDateHour.toDate().year,
    widget.currentTask.finishDateHour.toDate().month,
    widget.currentTask.finishDateHour.toDate().day,
  );
  late TimeOfDay _finalTime =  TimeOfDay(
    hour: widget.currentTask.finishDateHour.toDate().hour,
    minute: widget.currentTask.finishDateHour.toDate().minute,
  );  

  late int _priority = widget.currentTask.taskPriority;
  late String _description = widget.currentTask.description;

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

  void updatePriority(int priority) {
    setState(() {
      _priority = priority;
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
    ScrollController scrollController = ScrollController();
    ScrollController scrollController2 = ScrollController();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? const Color.fromARGB(255, 0, 80, 200)
                              : const Color.fromARGB(255, 255, 123, 0),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        width: double.infinity,
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 25, right: 30, bottom: 25),
                          child: StringInput(
                            initialValue: _title,
                            onNameChanged: updateTitle,
                            hintName: "Title",
                            maximumLength: 14,
                            noRegex: true,
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 300,
                            child: DateTimePicker(
                              onDateSelected: updateFinalDate,
                              onTimeSelected: (TimeOfDay time) {
                                updateFinalTime(time);
                              },
                              initialDate: _finalDate,
                              initialTime: _finalTime,
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            DateFormat.yMMMd().add_jms().format(widget.currentTask.creationDateHour.toDate()),
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkTheme? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Task Priority:',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkTheme? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 25),
                          SizedBox(
                            width: 240,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: NumberInput(
                                initialValue: _priority,
                                onNumberChanged: updatePriority,
                                hintName: "1 to 5 (1, 2, 3, 4 or 5)",
                              )
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Task Status:',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkTheme? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 25),
                          widget.currentTask.taskStatus
                            ? Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkTheme? const Color.fromARGB(255, 0, 202, 8) : const Color.fromARGB(255, 0, 154, 6),
                                ),
                              )
                            : const Text(
                                'Not completed',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              )
                        ],
                      )
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme
                          ? const Color.fromARGB(255, 0, 80, 200)
                          : const Color.fromARGB(255, 255, 175, 100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: double.infinity,
                      height: 275,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Scrollbar(
                          controller: scrollController2,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: scrollController2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 0, right: 12, bottom: 10),
                                child: StringInput(
                                  initialValue: _description,
                                  onNameChanged: updateDescription,
                                  hintName: "Description",
                                  multipleLines: true,
                                  noRegex: true
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                CircleAvatar(
                  backgroundColor: isDarkTheme
                    ? Colors.black
                    : const Color.fromRGBO(217, 217, 217, 1),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(task: widget.currentTask),
                        ),
                      );
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
                    ? const Color.fromARGB(255, 230, 170, 0)
                                  : const Color.fromARGB(255, 255, 210, 0),
                  child: TextButton(
                    onPressed: () {
                      _showArchiveConfirmationDialog(context, widget.currentTask);
                    },
                    // Important to make it zero inside the button so it gets centered
                    // instead of inheriting the padding from the positioning of the avatar
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      Icons.inventory_rounded,
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
                        await FirestoreUtils.editTask(
                          context,
                          widget.currentTask.id,
                          _title,
                          _finalDate,
                          _finalTime,
                          _priority,
                          _description
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(task: widget.currentTask),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Task edition has failed'),
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
      ),
    );
  }
}

void _showArchiveConfirmationDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Archive'),
        content: const Text('Are you sure you want to archive this task? This action is irreversible.'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {                 
                await FirestoreUtils.archiveTask(task.id, isAutomatic: false);

                // Navigate back to the main screen
                Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false);

                showDialog(
                  context: context,
                  barrierDismissible: false, // Disables dismiss by tapping outside
                  builder: (BuildContext context) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: const Text('Task Archived'),
                        content: const Text('Your task has been archived successfully.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Proceed'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('There was an error archiving the task. Please try again or contact support.'),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 212, 190, 0),
            ),
            child: const Text('Yes, Archive'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the archive confirmation dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
