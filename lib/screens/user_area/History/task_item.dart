import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/screens/user_area/History/task_history_details.dart';

class TaskListItem extends StatelessWidget {
  final ArchivedTask task;
  final VoidCallback? onTaskUpdated;

  const TaskListItem({
    super.key, 
    required this.task,
    this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 30),
        decoration: BoxDecoration(
          color: _getPriorityColor(task.taskPriority),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat.yMMMd().add_jms().format(task.finishDateHour.toDate()),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                navigateToDetailsScreen(context, task);
              },
              style: TextButton.styleFrom(
                backgroundColor: _getPriorityColor(task.taskPriority, light: true),
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

  Color _getPriorityColor(int priority, {bool light = false}) {
    switch (priority) {
      case 1:
        return light ? const Color.fromARGB(255, 125, 192, 218) : const Color.fromRGBO(51, 172, 221, 1);
      case 2:
        return light ? const Color.fromARGB(255, 130, 212, 151) : const Color.fromRGBO(53, 219, 95, 1);
      case 3:
        return light ? const Color.fromARGB(255, 232, 219, 115) : const Color.fromARGB(255, 240, 212, 0);
      case 4:
        return light ? const Color.fromARGB(255, 255, 180, 110) : const Color.fromRGBO(255, 122, 0, 1);
      default:
        return light ? const Color.fromARGB(255, 207, 115, 100) : const Color.fromRGBO(207, 57, 29, 1);
    }
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
