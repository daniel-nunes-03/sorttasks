// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/List/task_list_details.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<Task>> _fetchDataFuture;
  
  // Sorting options
  String _sortField = 'taskPriority';
  bool _isDescending = true;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
  }

  Future<List<Task>> fetchData() async {
    // Retrieve the ID of the logged-in user
    String? loggedInUserId = SorttasksApp.loggedInUser?.uid;

    // Auto-archive outdated tasks
    await FirestoreUtils.autoArchiveTasks(loggedInUserId);

    // Get the tasks owned by the logged-in user
    List<Task> tasks = await FirestoreUtils.getOwnedTasks(loggedInUserId, _sortField, _isDescending);

    return tasks;
  }

  void _changeSortOrder(String field, bool descending) {
    setState(() {
      _sortField = field;
      _isDescending = descending;
      _fetchDataFuture = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (SorttasksApp.loggedInUser == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const SizedBox.shrink();
    }

    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    final scrollcontroller = ScrollController();

    return Scaffold(
      body: Container(
        color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, top: 10, right: 20),
                child: Scrollbar(
                  controller: scrollcontroller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollcontroller,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 175,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('title', false),
                                child: Text(
                                  'A-Z',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('title', true),
                                child: Text(
                                  'Z-A',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('taskPriority', true),
                                child: Icon(
                                  Icons.filter_alt_off,
                                  color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "Creation Date:",
                                style: TextStyle(
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('creationDateHour', false),
                                child: Text(
                                  'Older-Newer',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('creationDateHour', true),
                                child: Text(
                                  'Newer-Older',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "Finish Date:",
                                style: TextStyle(
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('finishDateHour', false),
                                child: Text(
                                  'Older-Newer',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('finishDateHour', true),
                                child: Text(
                                  'Newer-Older',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "Priority:",
                                style: TextStyle(
                                  color: isDarkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('taskPriority', false),
                                child: Text(
                                  'Lower-Higher',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextButton(
                                onPressed: () => _changeSortOrder('taskPriority', true),
                                child: Text(
                                  'Higher-Lower',
                                  style: TextStyle(
                                    color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
                                  ),
                                )
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // List of tasks or loading indicator/message
            Expanded(
              child: FutureBuilder<List<Task>>(
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
                    List<Task> userTasks = snapshot.data ?? [];

                    return Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: userTasks.isEmpty
                            ? Center(
                                child: Text(
                                  'No tasks owned.',
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
                                  Task task = userTasks[index];
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
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 75,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 30, bottom: 20),
                  child: CircleAvatar(
                    backgroundColor: isDarkTheme
                      ? Colors.black
                      : const Color.fromRGBO(217, 217, 217, 1),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/task_add');
                      },
                      // Important to make it zero inside the button so it gets centered
                      // instead of inheriting the padding from the positioning of the avatar
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.add,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListItem extends StatefulWidget {
  final Task task;
  final VoidCallback? onTaskUpdated; // Callback function to trigger a refresh

  const _TaskListItem({required this.task, this.onTaskUpdated});

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<_TaskListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 30),
        decoration: BoxDecoration(
          color: 
            widget.task.taskPriority == 1 
              ? const Color.fromRGBO(51, 172, 221, 1)
              : widget.task.taskPriority == 2
                ? const Color.fromRGBO(53, 219, 95, 1)
                : widget.task.taskPriority == 3
                  ? const Color.fromARGB(255, 240, 212, 0)
                  : widget.task.taskPriority == 4
                    ? const Color.fromRGBO(255, 122, 0, 1)
                    : const Color.fromRGBO(207, 57, 29, 1),
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
                  DateFormat.yMMMd().add_jms().format(widget.task.finishDateHour.toDate()),
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
                    ? const Color.fromARGB(255, 125, 192, 218)
                    : widget.task.taskPriority == 2
                      ? const Color.fromARGB(255, 130, 212, 151)
                      : widget.task.taskPriority == 3
                        ? const Color.fromARGB(255, 232, 219, 115)
                        : widget.task.taskPriority == 4
                          ? const Color.fromARGB(255, 255, 180, 110)
                          : const Color.fromARGB(255, 207, 115, 100),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToDetailsScreen(BuildContext context, Task task) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailsScreen(task: task),
    ),
  );
}
