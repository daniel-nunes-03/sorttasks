// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/History/task_history_details.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  TaskHistoryState createState() => TaskHistoryState();
}

class TaskHistoryState extends State<TaskHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<ArchivedTask>> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
  }

  Future<List<ArchivedTask>> fetchData() async {
    // Step 1: Retrieve the ID of the logged-in user
    String? loggedInUserId = SorttasksApp.loggedInUser?.uid;

    // Step 2: Get the tasks owned by the logged-in user
    List<ArchivedTask> tasks = await FirestoreUtils.getOwnedHistory(loggedInUserId);

    return tasks;
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
      body: Container(
        color: isDarkTheme
          ? const Color.fromRGBO(45, 45, 45, 1)
          : Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
              child: Center(
                child: Text('LIST -> First Container'),
              ),
            ),
            // List of tasks or loading indicator/message
            Expanded(
              child: FutureBuilder<List<ArchivedTask>>(
                future: _fetchDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<ArchivedTask> userTasks = snapshot.data ?? [];

                    return Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      child: Container (
                        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: userTasks.isEmpty
                          ? Center(
                              child: Text(
                                'No archived tasks.',
                                style: TextStyle(
                                  color: isDarkTheme? Colors.yellow : const Color.fromARGB(255, 210, 14, 0),
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: userTasks.length,
                              itemBuilder: (context, index) {
                                ArchivedTask task = userTasks[index];
                                return _TaskListItem(
                                  task: task,
                                  onTaskUpdated: () {
                                    // Trigger a refresh when a task is updated
                                    setState(() {
                                      _fetchDataFuture = fetchData();
                                    });
                                  },
                                );
                              },
                            ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListItem extends StatefulWidget {
  final ArchivedTask task;
  final VoidCallback? onTaskUpdated; // Callback function to trigger a refresh

  const _TaskListItem({required this.task, this.onTaskUpdated});

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<_TaskListItem> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 30),
        decoration: BoxDecoration(
          color: 
            widget.task.taskPriority == 1 
              ? const Color.fromRGBO(0, 163, 255, 1) 
              : widget.task.taskPriority == 2
                ? const Color.fromRGBO(51, 205, 0, 1) 
                : widget.task.taskPriority == 3
                  ? const Color.fromRGBO(255, 225, 0, 1) 
                  : widget.task.taskPriority == 4
                    ? const Color.fromRGBO(255, 122, 0, 1) 
                    : const Color.fromRGBO(255, 0, 0, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.task.finishDateHour,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                navigateToDetailsScreen(context, widget.task);
              },
              style: TextButton.styleFrom(
                backgroundColor: 
                  widget.task.taskPriority == 1 
                    ? const Color.fromRGBO(0, 163, 255, 1) 
                    : widget.task.taskPriority == 2
                      ? const Color.fromRGBO(51, 205, 0, 1) 
                      : widget.task.taskPriority == 3
                        ? const Color.fromRGBO(255, 225, 0, 1) 
                        : widget.task.taskPriority == 4
                          ? const Color.fromRGBO(255, 122, 0, 1) 
                          : const Color.fromRGBO(255, 0, 0, 1),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: isDarkTheme ? Colors.white : Colors.black,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToDetailsScreen(BuildContext context, ArchivedTask task) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => TaskHistoryDetailsScreen(task: task),
    ),
  );
}
