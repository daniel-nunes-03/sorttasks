// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/List/task_list_details.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
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
  late String _finishDateHour = widget.currentTask.finishDateHour;
  late int _priority = widget.currentTask.taskPriority;
  late bool _status = widget.currentTask.taskStatus;
  late String _description = widget.currentTask.description;

  void updateTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void updateFinishDateHour(String finishDateHour){
    setState(() {
      _finishDateHour = finishDateHour;
    });
  }

  void updatePriority(int priority) {
    setState(() {
      _priority = priority;
    });
  }

  void updateStatus(bool status) {
    setState(() {
      _status = status;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? const Color.fromARGB(255, 0, 80, 200)
                                  : const Color.fromARGB(255, 255, 123, 0),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            width: 310,
                            height: 80,
                            child: Center(
                              child: StringInput(
                                initialValue: _title,
                                onNameChanged: updateTitle,
                                hintName: "Title",
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: isDarkTheme
                              ? const Color.fromARGB(255, 230, 170, 0)
                              : const Color.fromARGB(255, 255, 210, 0),
                            child: TextButton(
                              onPressed: () {
                                // Logic to go to edit screen
                                print("EDIT SCREEN");
                              },
                              // Important to make it zero inside the button so it gets centered
                              // instead of inheriting the padding from the positioning of the avatar
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: isDarkTheme ? Colors.white : Colors.black,
                                size: 30,
                              ),
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
                          StringInput(
                            initialValue: _finishDateHour,
                            onNameChanged: updateFinishDateHour,
                            hintName: "Finish Date&Hour",
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
                            widget.currentTask.creationDateHour,
                            style: TextStyle(
                              fontSize: 18,
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
                          NumberInput(
                            initialValue: _priority,
                            onNumberChanged: updatePriority,
                            hintName: "Task Priority",
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${widget.currentTask.taskPriority} / 5',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkTheme? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          CircleAvatar(
                            backgroundColor: widget.currentTask.taskPriority == 1 
                              ? const Color.fromRGBO(0, 163, 255, 1) 
                              : widget.currentTask.taskPriority == 2
                                ? const Color.fromRGBO(51, 205, 0, 1) 
                                : widget.currentTask.taskPriority == 3
                                  ? const Color.fromRGBO(255, 225, 0, 1) 
                                  : widget.currentTask.taskPriority == 4
                                    ? const Color.fromRGBO(255, 122, 0, 1) 
                                    : const Color.fromRGBO(255, 0, 0, 1),
                          )
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
                      height: 400,
                      child: Scrollbar(
                        controller: scrollController2,
                        child: SingleChildScrollView(
                          controller: scrollController2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.currentTask.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isDarkTheme ? Colors.white : Colors.black,
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
                    ? const Color.fromRGBO(255, 0, 0, 0.7)
                    : Colors.red,
                  child: TextButton(
                    onPressed: () {
                      // DELETE LOGIC
                      print('delete event');
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
