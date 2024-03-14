import 'package:flutter/material.dart';
import 'package:sorttasks/widgets/main_screen_appbar.dart';

class TaskHistoryScreen extends StatefulWidget {
  const TaskHistoryScreen({super.key});

  @override
  TaskHistoryState createState() => TaskHistoryState();
}

class TaskHistoryState extends State<TaskHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Task History Screen'),
      ),
    );
  }
}
