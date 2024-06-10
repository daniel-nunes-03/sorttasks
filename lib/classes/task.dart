import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String lowercaseTitle;
  Timestamp finishDateHour;
  Timestamp creationDateHour;
  int taskPriority;
  String description;

  // Constructor with named parameters and default values
  Task({
    required this.id,
    required this.title,
    required this.lowercaseTitle,
    required this.finishDateHour,
    required this.creationDateHour,
    required this.taskPriority,
    required this.description
  });

  // Factory constructor to create an Task from a map
  factory Task.fromMap(String docId, Map<String, dynamic> map) {
    final String id = docId;
    final String title = map['title'] as String;
    final String lowercaseTitle = map['lowercaseTitle'] as String;
    final Timestamp finishDateHour = map['finishDateHour'] as Timestamp;
    final Timestamp creationDateHour = map['creationDateHour'] as Timestamp;
    final int taskPriority = map['taskPriority'] as int;
    final String description = map['description'] as String;

    return Task(
      id: id,
      title: title,
      lowercaseTitle: lowercaseTitle,
      finishDateHour: finishDateHour,
      creationDateHour: creationDateHour,
      taskPriority: taskPriority,
      description: description
    );
  }

  // Convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lowercaseTitle': lowercaseTitle,
      'finishDateHour': finishDateHour,
      'creationDateHour': creationDateHour,
      'taskPriority': taskPriority,
      'description': description,
    };
  }

}
