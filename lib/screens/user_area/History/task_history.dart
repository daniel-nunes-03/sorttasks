// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
import 'package:sorttasks/main.dart';
import 'package:sorttasks/screens/user_area/task_listing.dart';
import 'package:sorttasks/screens/user_area/History/task_item.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  TaskHistoryState createState() => TaskHistoryState();
}

class TaskHistoryState extends State<TaskHistoryScreen> {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<ArchivedTask>> _fetchDataFuture;

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

  Future<List<ArchivedTask>> fetchData() async {
    String? loggedInUserId = SorttasksApp.loggedInUser?.uid;
    return await FirestoreUtils.getOwnedHistory(loggedInUserId, _sortField, _isDescending, _searchQuery);
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
        child: TaskList<ArchivedTask>(
          scrollController: _scrollController2,
          searchController: _searchController,
          fetchDataFuture: _fetchDataFuture,
          sortField: _sortField,
          isDescending: _isDescending,
          isDarkTheme: isDarkTheme,
          changeSortOrder: _changeSortOrder,
          showArchiveDate: true,
          buildTaskItem: (task) {
            return TaskListItem(
              task: task
            );
          },
        ),
      ),
    );
  }
}
