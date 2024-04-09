// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sorttasks/main.dart';

class FirestoreUtils {

  // 'USERS' COLLECTION IN FIRESTORE

  static Future<Map<String, String>?> getUserData() async {
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
          String creationDate = userData['creationDate'];

          return {'firstName': firstName, 'lastName': lastName, 'creationDate': creationDate};
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
        'creationDate': "DD/MM/YYYY PLACEHOLDER",
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

  static Future<String?> getLoggedInUserId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      return currentUser?.uid;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting logged-in user ID: $e');
      }
      return null;
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
      // Check if the email is already in use by attempting to sign in with it
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If sign-in succeeds, it means the email is already in use
      await FirebaseAuth.instance.signOut();
      
      return false;
    } catch (e) {
      // If sign-in fails, it means the email is available
      return true;
    }
  }

  // 'TASKS' COLLECTION IN FIRESTORE

  static Future<void> createTask(
    BuildContext context,
    String title,
    String finishDateHour,
    String creationDateHour,
    int taskPriority,
    bool taskStatus,
    String description
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
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

}
