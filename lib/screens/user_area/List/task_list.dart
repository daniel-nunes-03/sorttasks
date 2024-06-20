// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/task_listing.dart';
import 'package:sorttasks/screens/user_area/List/task_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskListScreen> {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Task>> _fetchDataFuture;

  String _sortField = 'taskPriority';
  bool _isDescending = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchDataFuture = fetchData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text.toLowerCase()) {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _fetchDataFuture = fetchData();
      });
    }
  }

  void _changeSortOrder(String field, bool descending) {
    if (_sortField != field || _isDescending != descending) {
      setState(() {
        _sortField = field;
        _isDescending = descending;
        _fetchDataFuture = fetchData();
      });
    }
  }

  Future<List<Task>> fetchData() async {
    String? loggedInUserId = SorttasksApp.loggedInUser?.uid;
    await FirestoreUtils.autoArchiveTasks(loggedInUserId);
    List<Task> tasks = await FirestoreUtils.getOwnedTasks(loggedInUserId, _sortField, _isDescending, _searchQuery);
    return tasks;
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

    return Scaffold(
      body: Container(
        color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
        child: TaskList<Task>(
          scrollController: _scrollController2,
          searchController: _searchController,
          fetchDataFuture: _fetchDataFuture,
          sortField: _sortField,
          isDescending: _isDescending,
          isDarkTheme: isDarkTheme,
          changeSortOrder: _changeSortOrder,
          showArchiveDate: false,
          buildTaskItem: (task) {
            return TaskListItem(
              task: task
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/task_add');
        },
        backgroundColor: isDarkTheme
          ? Colors.black
          : const Color.fromRGBO(217, 217, 217, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
        ),
        child: Icon(
          Icons.add,
          color: isDarkTheme ? Colors.white : Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
