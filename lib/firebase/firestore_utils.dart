// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/classes/task.dart' as sorttasks_task;
import 'package:sorttasks/main.dart';

class FirestoreUtils {

  // 'USERS' COLLECTION IN FIRESTORE
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        DocumentSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
          String profileImageUrl = await _retrieveProfileImageUrl(currentUser.uid);

          userData['profileImageUrl'] = profileImageUrl;
          return userData;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting authenticated user data: $e');
      }
      return null;
    }
  }

  static Future<String> _retrieveProfileImageUrl(String userId) async {
    try {
      Reference imageRef = FirebaseStorage.instance.ref().child('users/$userId/profile_image.jpg');
      String downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving profile image URL: $e');
      }
      return '';  // Return null if image not found
    }
  }

  // USER UPDATE
  static Future<bool> updateUser(BuildContext context, String newEmail, String newPassword, String currentEmail) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        bool isEmailChanged = newEmail != currentEmail;

        await currentUser.updatePassword(newPassword);

        if (isEmailChanged) {
          // Update authenticated user's email
          await currentUser.verifyBeforeUpdateEmail(newEmail);
          await currentUser.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email updated successfully. Please verify your new email address. You will need to login again.'),
              duration: Duration(seconds: 15),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password updated successfully. You will need to login again.'),
              duration: Duration(seconds: 8),
            ),
          );
        }

        // Log out the user after email update to force reauthentication
        await FirebaseAuth.instance.signOut();
        SorttasksApp.setLoggedInUser(null);
        Navigator.pushReplacementNamed(context, '/login');
        
        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user email and password: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating email and password. Please try again.'),
          duration: Duration(seconds: 5),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  static Future<bool> updateUserDetails(BuildContext context, String newFirstName, String newLastName) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> currentUserData = snapshot.data() as Map<String, dynamic>;

        bool changed = (currentUserData['firstName'] != newFirstName) || (currentUserData['lastName'] != newLastName);

        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'firstName': newFirstName,
          'lastName': newLastName,
        });

        if (changed) {
          Navigator.pushReplacementNamed(context, '/profile_view');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User details updated successfully.'),
              duration: Duration(seconds: 3),
            ),
          );
        }

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user details: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating user details. Please try again.'),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  // Recover password
  static Future<bool> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();  // close the previous popup before opening the next one
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset'),
            content: const Text('A password reset link has been sent to your email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // This value is used for testing only
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while sending the password reset email. Please try again or contact support.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    // This value is used for testing only
    return false;
  }

  // USER CREATE AND DELETE
  static Future<bool> addUser(String email, String firstName, String lastName, String password) async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Create a new folder with user's ID as name in Firebase Storage
      FirebaseStorage.instance.ref().child('users').child(userId);
      
      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'creationDate': DateTime.now(),
        'createdTasks': 0,
        'completedTasks': 0
      });

      // Create folder for tasks and archived tasks
      FirebaseStorage.instance.ref().child('tasksMain').child('tasks').child(userId);
      FirebaseStorage.instance.ref().child('tasksMain').child('archivedTasks').child(userId);

      await userCredential.user!.sendEmailVerification();

      // This value is used for testing only
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user to Firestore: $e');
      }
      rethrow;
    }
  }

  static Future<bool> _deleteUserImage(String userId) async {
    final folderRef = FirebaseStorage.instance.ref().child('users').child(userId);

    try {
      // Check if the folder exists by listing items within it
      final result = await folderRef.listAll();
      if (result.items.isNotEmpty) {
        await folderRef.delete();  // If the list is not empty, folder exists, therefore delete it
      }

      // This value is used for testing only
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting folder: $e');
      }
    }

    // This value is used for testing only
    return false;
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      // Delete the user server folders/documents
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
        .collection('tasksMain')
        .doc('tasks')
        .collection(userId)
        .get();

      for (QueryDocumentSnapshot eventSnapshot in eventsSnapshot.docs) {
        await eventSnapshot.reference.delete();
      }

      eventsSnapshot = await FirebaseFirestore.instance
        .collection('tasksMain')
        .doc('archivedTasks')
        .collection(userId)
        .get();

      for (QueryDocumentSnapshot eventSnapshot in eventsSnapshot.docs) {
        await eventSnapshot.reference.delete();
      }

      await _deleteUserImage(userId);

      await FirebaseAuth.instance.currentUser?.delete();

      // Delete the user local settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('sorttasks_email');
      await prefs.remove('sorttasks_password');

      // This value is used for testing only
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      rethrow;
    }
  }

  // USER AUTHENTICATION AND VERIFICATION
  static Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SorttasksApp.setLoggedInUser(userCredential.user);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Authentication failed: $e');
      }
      return false;
    }
  }

  static Future<bool> verifyPassword(String password) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: currentUser.email!, password: password);
        await currentUser.reauthenticateWithCredential(credential);
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying password: $e');
      }
      return false;
    }
  }

  static Future<bool> checkEmailVerification() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.reload();
        return currentUser.emailVerified;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email verification: $e');
      }
      return false;
    }
  }

  static Future<bool> checkEmailAvailable(String email, String password) async {
    try {
      // Attempt to sign in with the provided email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If sign-in succeeds, the email is already in use
      await FirebaseAuth.instance.signOut();
      return false;
    } catch (e) {
      // Check if the error is due to the email already being registered
      if (e is FirebaseAuthException && e.code == 'wrong-password') {
        // Email exists but password is incorrect
        return false;
      }
      // For all other errors, including email not being registered
      return true;
    }
  }

  static Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(userId)
        .child('profile_image.jpg');

      await storageRef.putFile(imageFile);

      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  static Future<bool> removeImage(String userId) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(userId)
        .child('profile_image.jpg');

      await storageRef.delete();

      // This value is used for testing only
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error removing image: $e');
      }
    }

    // This value is used for testing only
    return false;
  }

  // 'TASKS' COLLECTION IN FIRESTORE
  static Future<bool> createTask(
    BuildContext context,
    String title,
    DateTime finalDate,
    TimeOfDay finalTime,
    int taskPriority,
    String description
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final DateTime finishDateHour = DateTime(
          finalDate.year,
          finalDate.month,
          finalDate.day,
          finalTime.hour,
          finalTime.minute
        );

        final DateTime creationDateHour = DateTime.now();

        bool notification3D = false;
        bool notification1D = false;

        // If notification in 3 days doesnt apply, "true"
        DateTime threeDaysFromNow = DateTime.now().add(const Duration(days: 3));
        if (finishDateHour.isBefore(threeDaysFromNow)) {
          notification3D = true;
        }

        // If notification in 1 day doesnt apply, "true"
        DateTime oneDayFromNow = DateTime.now().add(const Duration(days: 1));
        if (finishDateHour.isBefore(oneDayFromNow)) {
          notification1D = true;
        }

        // Create a document for the current user with the input data
        await FirebaseFirestore.instance.collection('tasksMain').doc('tasks').collection(currentUser.uid).doc().set({
          'title': title,
          'lowercaseTitle': title.toLowerCase(),
          'finishDateHour': finishDateHour,
          'creationDateHour': creationDateHour,
          'taskPriority': taskPriority,
          'description': description,
          'notification3D': notification3D,
          'notification1D': notification1D
        });

        // Update the 'createdTasks' field in the user's document
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(1),
        });

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating the task: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating the task. Please try again.'),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  static Future<bool> editTask(
    BuildContext context,
    String taskID,
    String title,
    DateTime finalDate,
    TimeOfDay finalTime,
    int taskPriority,
    String description
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final DateTime finishDateHour = DateTime(
          finalDate.year,
          finalDate.month,
          finalDate.day,
          finalTime.hour,
          finalTime.minute
        );

        bool notification3D = false;
        bool notification1D = false;

        // If notification in 3 days doesnt apply, "true"
        DateTime threeDaysFromNow = DateTime.now().add(const Duration(days: 3));
        if (finishDateHour.isBefore(threeDaysFromNow)) {
          notification3D = true;
        }

        // If notification in 1 day doesnt apply, "true"
        DateTime oneDayFromNow = DateTime.now().add(const Duration(days: 1));
        if (finishDateHour.isBefore(oneDayFromNow)) {
          notification1D = true;
        }
        
        DocumentReference taskReference = 
          FirebaseFirestore.instance.collection('tasksMain').doc('tasks').collection(currentUser.uid).doc(taskID);

        await taskReference.update({
          'title': title,
          'lowercaseTitle': title.toLowerCase(),
          'finishDateHour': finishDateHour,
          'taskPriority': taskPriority,
          'description': description,
          'notification3D': notification3D,
          'notification1D': notification1D
        });

        // This value is used for testing only
        return true;                
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing the task: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error editing the task. Please try again.'),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  static Future<bool> deleteTask(BuildContext context, String taskId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete Task
        await FirebaseFirestore.instance.collection('tasksMain').doc('tasks').collection(currentUser.uid).doc(taskId).delete();

        // Decrement 'createdTasks' field by 1
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(-1),
        });

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting the task: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting the task. Please try again.'),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  static Future<List<sorttasks_task.Task>> _taskList(String? userID, String sortField, bool isDescending) async {
    try {
      if (userID != null) {
        // Query to get tasks from the authenticated user
        Query query = FirebaseFirestore.instance
          .collection('tasksMain')
          .doc('tasks')
          .collection(SorttasksApp.loggedInUser!.uid)
          .orderBy(sortField, descending: isDescending);

        QuerySnapshot querySnapshot = await query.get();
        return querySnapshot.docs.map((doc) => sorttasks_task.Task.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
      } else {
        if (kDebugMode) {
          print('Error: User ID is null.');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting owned tasks: $e');
      }
      return [];
    }
  }

  static Future<List<sorttasks_task.Task>> getOwnedTasks(String? userID, String sortField, bool isDescending, String searchQuery) async {
    try {
      if (userID != null) {
        // Retrieve all tasks owned by the user
        List<sorttasks_task.Task> allTasks = await FirestoreUtils._taskList(userID, sortField, isDescending);

        // Filter tasks based on the search query (substring match)
        List<sorttasks_task.Task> filteredTasks = allTasks.where(
          (task) => task.lowercaseTitle.contains(searchQuery.toLowerCase())
        ).toList();

        return filteredTasks;
      } else {
        if (kDebugMode) {
          print('Error: User ID is null.');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting owned tasks: $e');
      }
      return [];
    }
  }

  static Future<sorttasks_task.Task> getTaskDetails(String taskID) async {
    try {
      // Reference to the specific document
      DocumentReference taskReference = FirebaseFirestore.instance
        .collection('tasksMain')
        .doc('tasks')
        .collection(SorttasksApp.loggedInUser!.uid)
        .doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Convert the document data to an Event object
        return sorttasks_task.Task.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
      } else {
        // Handle the case where the event with the given ID does not exist
        if (kDebugMode) {
          print('Task not found');
        }
        throw Exception("Task not found");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting task by ID: $e');
      }
      rethrow;
    }
  }

  // 'ARCHIVEDTASKS' COLLECTION IN FIREBASE

  static Future<bool> archiveTask(String taskID, {required bool isAutomatic}) async {
    try {
      // Reference to the specific document
      DocumentReference taskReference = 
        FirebaseFirestore.instance.collection('tasksMain').doc('tasks').collection(SorttasksApp.loggedInUser!.uid).doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Get data from the snapshot
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (isAutomatic) {
          data['taskStatus'] = false;
          data['archivedDateHour'] = data['finishDateHour'];
        } else {
          data['taskStatus'] = true;
          data['archivedDateHour'] = DateTime.now();
        }

        // Create a new document in 'archivedTasks' with the same data
        await FirebaseFirestore.instance
          .collection('tasksMain')
          .doc('archivedTasks')
          .collection(SorttasksApp.loggedInUser!.uid)
          .doc(taskID).set(data);

        // Delete the original task document from the 'tasks' collection
        await taskReference.delete();

        // This value is used for testing only
        return true;
      } else {
        // Handle the case where the event with the given ID does not exist
        if (kDebugMode) {
          print('Task not found');
        }
        throw Exception("Task not found");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error archiving the task: $e');
      }
      rethrow;
    }
  }

  static Future<bool> autoArchiveTasks(String? userID) async {
    try {
      if (userID != null) {
        CollectionReference tasksCollection = 
          FirebaseFirestore.instance.collection('tasksMain').doc('tasks').collection(SorttasksApp.loggedInUser!.uid);

        // Get user tasks where finishDateHour is in the past
        QuerySnapshot querySnapshot = await tasksCollection
          .where('finishDateHour', isLessThan: DateTime.now())
          .get();

        // Archive each task
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String taskId = doc.id;
          await archiveTask(taskId, isAutomatic: true);
        }

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error auto-archiving tasks: $e');
      }
    }

    // This value is used for testing only
    return false;
  }

  static Future<bool> deleteArchivedTask(BuildContext context, String taskId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete Archived Task
        await FirebaseFirestore.instance.collection('tasksMain').doc('archivedTasks')
          .collection(SorttasksApp.loggedInUser!.uid).doc(taskId).delete();

        // Decrement 'createdTasks' field by 1
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(-1),
        });

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting the task: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting the task. Please try again.'),
        ),
      );
      rethrow;
    }

    // This value is used for testing only
    return false;
  }

  static Future<List<ArchivedTask>> _taskHistory(String? userID, String sortField, bool isDescending) async {
    try {
      if (userID != null) {
        // Query to get archived tasks from the authenticated user
        Query query = FirebaseFirestore.instance
          .collection('tasksMain')
          .doc('archivedTasks')
          .collection(userID)
          .orderBy(sortField, descending: isDescending);

        QuerySnapshot querySnapshot = await query.get();
        return querySnapshot.docs.map((doc) => ArchivedTask.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
      } else {
        if (kDebugMode) {
          print('Error: User ID is null.');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting owned archived tasks: $e');
      }
      return [];
    }
  }

  static Future<List<ArchivedTask>> getOwnedHistory(String? userID, String sortField, bool isDescending, String searchQuery) async {
    try {
      if (userID != null) {
        // Retrieve all archived tasks owned by the user
        List<ArchivedTask> allTasks = await FirestoreUtils._taskHistory(userID, sortField, isDescending);

        // Filter tasks based on the search query (substring match)
        List<ArchivedTask> filteredTasks = allTasks.where(
          (task) => task.lowercaseTitle.contains(searchQuery.toLowerCase())
        ).toList();

        return filteredTasks;
      } else {
        if (kDebugMode) {
          print('Error: User ID is null.');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting owned archived tasks: $e');
      }
      return [];
    }
  }

  static Future<ArchivedTask> getArchivedTaskDetails(String taskID) async {
    try {
      // Reference to the specific document
      DocumentReference taskReference = FirebaseFirestore.instance
        .collection('tasksMain')
        .doc('archivedTasks')
        .collection(SorttasksApp.loggedInUser!.uid)
        .doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Convert the document data to an Event object
        return ArchivedTask.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
      } else {
        // Handle the case where the event with the given ID does not exist
        if (kDebugMode) {
          print('Archived Task not found');
        }
        throw Exception("Archived Task not found");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting archived task by ID: $e');
      }
      rethrow;
    }
  }

  // PERIODIC TASK CHECKS

  static Future<bool> checkTasksDueWithin3Days() async {
    // If no user is logged in
    if (SorttasksApp.loggedInUser == null) {
      return false;
    }

    try {
      // Get user's tasks
      List<sorttasks_task.Task> tasks = await FirestoreUtils.getOwnedTasks(
        SorttasksApp.loggedInUser!.uid,
        'finishDateHour',
        true, // Assuming descending order for finishDateHour
        '',    // No search query needed
      );

      DateTime threeDaysFromNow = DateTime.now().add(const Duration(days: 3));
      DateTime oneDayFromNow = DateTime.now().add(const Duration(days: 1));

      // Check if any task's finishDateHour is within 3 days
      for (var task in tasks) {
        // Convert from Timestamp to Date
        DateTime taskFinishDateTime = task.finishDateHour.toDate();

        // If notification3D is appliable and still was not sent
        if (!task.notification3D) {
          if (taskFinishDateTime.isBefore(threeDaysFromNow)) {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: task.id.hashCode,
                channelKey: "task_channel",
                title: task.title,
                body: "${task.title} is due in 3 days."
              ),
            );

            // Notification is no longer appliable since it was sent once already
            
            await FirebaseFirestore.instance
              .collection('tasksMain')
              .doc('tasks')
              .collection(SorttasksApp.loggedInUser!.uid)
              .doc(task.id).update({
                'notification3D': true,
              });
          }
        }

        // If notification1D is appliable and still was not sent
        if (!task.notification1D) {
          if (taskFinishDateTime.isBefore(oneDayFromNow)) {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: task.id.hashCode,
                channelKey: "task_channel",
                title: task.title,
                body: "${task.title} is due in 1 day."
              ),
            );

            await FirebaseFirestore.instance
              .collection('tasksMain')
              .doc('tasks')
              .collection(SorttasksApp.loggedInUser!.uid)
              .doc(task.id).update({
                'notification1D': true,
              });
          }
        }

        // This value is used for testing only
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking tasks: $e');
      }
    }

    // This value is used for testing only
    return false;
  }

}
