import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivedTask {
  String id;
  String title;
  String lowercaseTitle;
  Timestamp archivedDateHour;
  Timestamp finishDateHour;
  Timestamp creationDateHour;
  int taskPriority;
  bool taskStatus;
  String description;
  bool notification3D;
  bool notification1D;

  // Constructor with named parameters and default values
  ArchivedTask({
    required this.id,
    required this.title,
    required this.lowercaseTitle,
    required this.archivedDateHour,
    required this.finishDateHour,
    required this.creationDateHour,
    required this.taskPriority,
    required this.taskStatus,
    required this.description,
    required this.notification3D,
    required this.notification1D
  });

  // Factory constructor to create an Task from a map
  factory ArchivedTask.fromMap(String docId, Map<String, dynamic> map) {
    final String id = docId;
    final String title = map['title'] as String;
    final String lowercaseTitle = map['lowercaseTitle'] as String;
    final Timestamp archivedDateHour = map['archivedDateHour'] as Timestamp;
    final Timestamp finishDateHour = map['finishDateHour'] as Timestamp;
    final Timestamp creationDateHour = map['creationDateHour'] as Timestamp;
    final int taskPriority = map['taskPriority'] as int;
    final bool taskStatus = map['taskStatus'] as bool;
    final String description = map['description'] as String;
    final bool notification3D = map['notification3D'] as bool;
    final bool notification1D = map['notification1D'] as bool;

    return ArchivedTask(
      id: id,
      title: title,
      lowercaseTitle: lowercaseTitle,
      archivedDateHour: archivedDateHour,
      finishDateHour: finishDateHour,
      creationDateHour: creationDateHour,
      taskPriority: taskPriority,
      taskStatus: taskStatus,
      description: description,
      notification3D: notification3D,
      notification1D: notification1D
    );
  }

  // Convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lowercaseTitle': lowercaseTitle,
      'archivedDateHour': archivedDateHour,
      'finishDateHour': finishDateHour,
      'creationDateHour': creationDateHour,
      'taskPriority': taskPriority,
      'taskStatus': taskStatus,
      'description': description,
      'notification3D': notification3D,
      'notification1D': notification1D
    };
  }

}
