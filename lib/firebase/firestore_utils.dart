// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sorttasks/classes/archived_task.dart';
import 'package:sorttasks/classes/task.dart';
import 'package:sorttasks/main.dart';

class FirestoreUtils {

  // 'USERS' COLLECTION IN FIRESTORE

  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Reference to the 'users' collection and the specific document
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

        // Fetch the document snapshot
        DocumentSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          // Access the user data from the snapshot
          Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
          String firstName = userData['firstName'];
          String lastName = userData['lastName'];
          Timestamp creationDate = userData['creationDate'];
          int createdTasks = userData['createdTasks'];
          int completedTasks = userData['completedTasks'];

          return {
            'firstName': firstName,
            'lastName': lastName,
            'creationDate': creationDate,
            'createdTasks': createdTasks,
            'completedTasks': completedTasks
          };
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

  // USER UPDATE

  static Future<void> updateUserPassword(BuildContext context, String newPassword) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user password: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating password. Please try again.'),
        ),
      );
      rethrow;
    }
  }

  static Future<void> updateUser(BuildContext context, String newEmail, String newPassword, String currentEmail) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Check if there are changes in email
        bool isEmailChanged = newEmail != currentEmail;

        // Update authenticated user's password
        await currentUser.updatePassword(newPassword);

        // Send verification email if email is changed
        if (isEmailChanged) {
          // Update authenticated user's email
          await currentUser.verifyBeforeUpdateEmail(newEmail);
          await currentUser.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email updated successfully. Please verify your new email address when possible. While you dont, you will need to use your old email. You will need to login again.'),
              duration: Duration(seconds: 15),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Passsword updated successfully. You will need to login again.'),
              duration: Duration(seconds: 8),
            ),
          );
        }
        
        // Log out the user after email update to force reauthentication
        await FirebaseAuth.instance.signOut();
        SorttasksApp.setLoggedInUser(null);
        Navigator.pushReplacementNamed(context, '/login');
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
  }

  static Future<void> updateUserDetails(BuildContext context, String newFirstName, String newLastName) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch the current user data from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> currentUserData = snapshot.data() as Map<String, dynamic>;

        // Check if there are changes in first name or last name
        bool changed = (currentUserData['firstName'] != newFirstName) || (currentUserData['lastName'] != newLastName);

        // Update Firestore document with the new data
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'firstName': newFirstName,
          'lastName': newLastName,
        });

        // Show a Snackbar if username changed
        if (changed) {
          Navigator.pushReplacementNamed(context, '/profile_view');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User details updated successfully.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
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
  }

  // USER CREATE AND DELETE

  static Future<void> addUser(String email, String firstName, String lastName, String password) async {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the ID of the newly created user
      String userId = userCredential.user!.uid;

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'creationDate': DateTime.now(),
        'createdTasks': 0,
        'completedTasks': 0
      });

      // Send verification email
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user to Firestore: $e');
      }
      rethrow;
    }
  }

  static Future<void> deleteUser(String userId) async {
    try {
      // Delete the user's document from the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete all tasks owned by the user from the 'tasks' collection
      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance.collection('tasks').where('userOwner', isEqualTo: userId).get();
      for (QueryDocumentSnapshot eventSnapshot in eventsSnapshot.docs) {
        await eventSnapshot.reference.delete();
      }

      /*

      // Delete all archivedTasks owned by the user from the 'archivedTasks' collection
      eventsSnapshot = await FirebaseFirestore.instance.collection('archivedTasks').where('userOwner', isEqualTo: userId).get();
      for (QueryDocumentSnapshot eventSnapshot in eventsSnapshot.docs) {
        await eventSnapshot.reference.delete();
      }
      
      */

      // Delete the user from authentication
      await FirebaseAuth.instance.currentUser?.delete();
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

      // Login was a success
      return true;
    } catch (e) {
      // Authentication failure
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
        // Use reauthentication to verify the password
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
        await currentUser.reload(); // Refresh user data

        // Check if the email is verified
        if (currentUser.emailVerified) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
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

  // 'TASKS' COLLECTION IN FIRESTORE

  Future<void> insertDate(BuildContext context, DateTime selectedDate, TimeOfDay selectedTime) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference tasks = firestore.collection('tasks');

    final DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute
    );

    try {
      await tasks.add({
        'dateHour': selectedDateTime,
        // You can add more fields here as needed
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task added successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add task: $e'),
      ));
    }
  }

  static Future<void> createTask(
    BuildContext context,
    String title,
    DateTime finalDate,
    TimeOfDay finalTime,
    int taskPriority,
    bool taskStatus,
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

        // Create a document for the current user with the input data
        await FirebaseFirestore.instance.collection('tasks').doc().set({
          'userID': currentUser.uid,
          'title': title,
          'finishDateHour': finishDateHour,
          'creationDateHour': creationDateHour,
          'taskPriority': taskPriority,
          'taskStatus': taskStatus,
          'description': description
        });

        // Update the 'createdTasks' field in the user's document
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(1),
        });
        
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
  }

  static Future<void> editTask(
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
        
        DocumentReference taskReference = FirebaseFirestore.instance.collection('tasks').doc(taskID);

        await taskReference.update({
          'title': title,
          'finishDateHour': finishDateHour,
          'taskPriority': taskPriority,
          'description': description
        });
                
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
  }

  static Future<void> deleteTask(BuildContext context, String taskId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete Task
        await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();

        // Decrement 'createdTasks' field by 1
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(-1),
        });
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
  }

  static Future<List<Task>> getOwnedTasks(String? userID) async {
    try {
      if (userID != null) {
        // Reference to the 'tasks' collection
        CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');

        // Query to get tasks where userID is equal to the input parameter,
        // sorted by taskPriority in descending order, then by finishDateHour in ascending order
        QuerySnapshot querySnapshot = await tasksCollection
          .where('userID', isEqualTo: userID)
          .orderBy('taskPriority', descending: true)
          .orderBy('finishDateHour', descending: false)
          .get();

        // Map query results to Task objects
        List<Task> userTasks = querySnapshot.docs.map((doc) {
          return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();

        return userTasks;
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

  static Future<Task> getTaskDetails(String taskID) async {
    try {
      // Reference to the 'tasks' collection and the specific document
      DocumentReference taskReference = FirebaseFirestore.instance.collection('tasks').doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Convert the document data to an Event object
        return Task.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
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

  static Future<void> archiveTask(String taskID) async {
    try {
      // Reference to the 'tasks' collection and the specific document
      DocumentReference taskReference = FirebaseFirestore.instance.collection('tasks').doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Get data from the snapshot
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        data['archivedDateHour'] = "";

        // Create a new document in the 'archivedTasks' collection with the same data
        await FirebaseFirestore.instance.collection('archivedTasks').doc(taskID).set(data);

        // Delete the original task document from the 'tasks' collection
        await taskReference.delete();
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

  static Future<void> deleteArchivedTask(BuildContext context, String taskId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete Archived Task
        await FirebaseFirestore.instance.collection('archivedTasks').doc(taskId).delete();

        // Decrement 'createdTasks' field by 1
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'createdTasks': FieldValue.increment(-1),
        });
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
  }

  static Future<List<ArchivedTask>> getOwnedHistory(String? userID) async {
    try {
      if (userID != null) {
        // Reference to the 'archivedTasks' collection
        CollectionReference tasksCollection = FirebaseFirestore.instance.collection('archivedTasks');

        // Query to get archivedTasks where userID is equal to the input parameter,
        // sorted by taskPriority in descending order, then by finishDateHour in ascending order
        QuerySnapshot querySnapshot = await tasksCollection
          .where('userID', isEqualTo: userID)
          .orderBy('taskPriority', descending: true)
          .orderBy('finishDateHour', descending: false)
          .get();

        // Map query results to ArchivedTask objects
        List<ArchivedTask> userTasks = querySnapshot.docs.map((doc) {
          return ArchivedTask.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();

        return userTasks;
      } else {
        if (kDebugMode) {
          print('Error: User ID is null.');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting owned history: $e');
      }
      return [];
    }
  }

  static Future<ArchivedTask> getArchivedTaskDetails(String taskID) async {
    try {
      // Reference to the 'archivedTasks' collection and the specific document
      DocumentReference taskReference = FirebaseFirestore.instance.collection('archivedTasks').doc(taskID);

      // Fetch the document snapshot
      DocumentSnapshot snapshot = await taskReference.get();

      if (snapshot.exists) {
        // Convert the document data to an Event object
        return ArchivedTask.fromMap(snapshot.id, snapshot.data() as Map<String, dynamic>);
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

}
