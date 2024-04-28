/*
class ArchivedTask {
  Task task; // Composition: ArchivedTask includes a Task

  String archivedDate;

  ArchivedTask({
    required this.task,
    required this.archivedDate,
  });

  factory ArchivedTask.fromMap(String docId, Map<String, dynamic> map) {
    final Task task = Task.fromMap(docId, map);
    // final archivedDate = DateTime.parse(map['archivedDate'] as String);
    final archivedDate = map['archivedDate'];

    return ArchivedTask(
      task: task,
      archivedDate: archivedDate,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> taskMap = task.toMap(); // Get map representation of Task
    // taskMap['archivedDate'] = archivedDate.toIso8601String(); // Add archivedDate
    taskMap['archivedDate'] = archivedDate;
    return taskMap;
  }
}
*/

class ArchivedTask {
  String id;
  String title;
  String? userID;
  String archivedDateHour;
  String finishDateHour;
  String creationDateHour;
  int taskPriority;
  bool taskStatus;
  String description;

  // Constructor with named parameters and default values
  ArchivedTask({
    required this.id,
    required this.title,
    required this.userID,
    required this.archivedDateHour,
    required this.finishDateHour,
    required this.creationDateHour,
    required this.taskPriority,
    required this.taskStatus,
    required this.description
  });

  // Factory constructor to create an Task from a map
  factory ArchivedTask.fromMap(String docId, Map<String, dynamic> map) {
    final String id = docId;
    final String title = map['title'] as String;
    final String? userID = map['userID'] as String?;
    final String archivedDateHour = map['archivedDateHour'] as String;
    final String finishDateHour = map['finishDateHour'] as String;
    final String creationDateHour = map['creationDateHour'] as String;
    final int taskPriority = map['taskPriority'] as int;
    final bool taskStatus = map['taskStatus'] as bool? ?? false;
    final String description = map['description'] as String;

    return ArchivedTask(
      id: id,
      title: title,
      userID: userID,
      archivedDateHour: archivedDateHour,
      finishDateHour: finishDateHour,
      creationDateHour: creationDateHour,
      taskPriority: taskPriority,
      taskStatus: taskStatus,
      description: description
    );
  }

  // Convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'userID': userID,
      'archivedDateHour': archivedDateHour,
      'finishDateHour': finishDateHour,
      'creationDateHour': creationDateHour,
      'taskPriority': taskPriority,
      'taskStatus': taskStatus,
      'description': description,
    };
  }

}
