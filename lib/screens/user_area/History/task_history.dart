import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';


class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  TaskHistoryState createState() => TaskHistoryState();
}

class TaskHistoryState extends State<TaskHistoryScreen> {
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
            child: Center(
              child: Text(
                'HISTORY -> First Container',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  color: isDarkTheme
                    ? const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(217, 217, 217, 1),
                  child: Center(
                    child: Text(
                      'HISTORY -> Middle Container - Scrollable',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
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
            child: Center(
              child: Text(
                'HISTORY -> Last Container',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
