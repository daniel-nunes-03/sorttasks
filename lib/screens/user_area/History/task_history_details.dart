// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/widgets/Misc/custom_appbar.dart';

class TaskHistoryDetailsScreen extends StatefulWidget {
  final ArchivedTask task;

  const TaskHistoryDetailsScreen({super.key, required this.task});

  @override
  TaskDetailsState createState() => TaskDetailsState();
}

class TaskDetailsState extends State<TaskHistoryDetailsScreen> {
  late ArchivedTask currentTask;
  bool _dataIsLoading = true;
  bool _noData = false;
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch the latest event data
      ArchivedTask latestTaskData = await FirestoreUtils.getArchivedTaskDetails(currentTask.id);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController1,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: 
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                  ? const Color.fromARGB(255, 70, 70, 70)
                                  : const Color.fromARGB(255, 220, 220, 220),
                                borderRadius: BorderRadius.circular(90),
                              ),
                              width: 310,
                              height: 80,
                              child: Center(
                                child: Text(
                                  currentTask.title,
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: isDarkTheme? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: isDarkTheme ? Colors.white : Colors.black,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      "Archived at:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 9.5),
                                    Text(
                                      DateFormat.yMMMd().add_jms().format(currentTask.archivedDateHour.toDate()),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: isDarkTheme ? Colors.white : Colors.black,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      "Finish Date:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateFormat.yMMMd().add_jms().format(currentTask.finishDateHour.toDate()),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: isDarkTheme ? Colors.white : Colors.black,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      "Created at:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 17),
                                    Text(
                                      DateFormat.yMMMd().add_jms().format(currentTask.creationDateHour.toDate()),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Text(
                                      'Task Priority:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      '${currentTask.taskPriority} / 5',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      backgroundColor: currentTask.taskPriority == 1 
                                        ? const Color.fromRGBO(51, 172, 221, 1)
                                        : currentTask.taskPriority == 2
                                          ? const Color.fromRGBO(53, 219, 95, 1)
                                          : currentTask.taskPriority == 3
                                            ? const Color.fromARGB(255, 240, 212, 0)
                                            : currentTask.taskPriority == 4
                                              ? const Color.fromRGBO(255, 122, 0, 1)
                                              : const Color.fromRGBO(207, 57, 29, 1),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Text(
                                      'Task Status:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isDarkTheme ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    currentTask.taskStatus
                                      ? Text(
                                          'Completed',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: isDarkTheme ? const Color.fromARGB(255, 0, 202, 8) : const Color.fromARGB(255, 0, 154, 6),
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                ? const Color.fromARGB(255, 70, 70, 70)
                                : const Color.fromARGB(255, 220, 220, 220),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: double.infinity,
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Scrollbar(
                                controller: _scrollController2,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _scrollController2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      currentTask.description,
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
                    ? const Color.fromRGBO(255, 0, 0, 0.7)
                    : Colors.red,
                  child: TextButton(
                    onPressed: () {
                      _passwordConfirmationPopup(context, currentTask);
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

void _passwordConfirmationPopup(BuildContext context, ArchivedTask task) async {
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
              try {
                // Validate the entered password using Firebase authentication
                bool isPasswordCorrect = await FirestoreUtils.verifyPassword(enteredPassword);

                Navigator.pop(context); // Close the password confirmation dialog

                if (isPasswordCorrect) {
                  _showDeleteConfirmationDialog(context, task);
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
                Navigator.of(context).pop();
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

void _showDeleteConfirmationDialog(BuildContext context, ArchivedTask task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {                 
                await FirestoreUtils.deleteArchivedTask(context, task.id);

                // Navigate back to the main screen
                Navigator.pushNamedAndRemoveUntil(context, '/main_screen', (route) => false);

                showDialog(
                  context: context,
                  barrierDismissible: false, // Disables dismiss by tapping outside
                  builder: (BuildContext context) {
                    return PopScope(
                      canPop: false,
                      child: AlertDialog(
                        title: const Text('Task Deleted'),
                        content: const Text('Your task has been deleted successfully.'),
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
                    content: Text('There was an error deleting the task. Please try again or contact support.'),
                    duration: Duration(seconds: 5),
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
