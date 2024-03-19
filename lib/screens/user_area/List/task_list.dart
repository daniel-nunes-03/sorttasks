import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListState createState() => TaskListState();
}

class TaskListState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            color: isDarkTheme
              ? const Color.fromRGBO(17, 17, 17, 1)
              : const Color.fromRGBO(217, 217, 217, 1),
            child: const Center(
              child: Text('LIST -> First Container'),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  color: isDarkTheme
                    ? const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(
                    child: Text('LIST -> Middle Container - Scrollable'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            color: isDarkTheme
              ? const Color.fromRGBO(17, 17, 17, 1)
              : const Color.fromRGBO(217, 217, 217, 1),
            child: const Center(
              child: Text('LIST -> Last Container'),
            ),
          ),
        ],
      ),
    );
  }
}
