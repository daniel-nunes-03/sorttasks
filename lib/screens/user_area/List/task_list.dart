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
      body: Container(
        color: isDarkTheme
          ? const Color.fromRGBO(45, 45, 45, 1)
          : Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 200,
              child: Center(
                child: Text('LIST -> First Container'),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Center(
                    child: Text(
                      'LIST -> Middle Container - Scrollable',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ),
            const SizedBox(
              height: 200,
              child: Center(
                child: Text('LIST -> Last Container'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
