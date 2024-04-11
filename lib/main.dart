import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase_options.dart';
import 'package:sorttasks/screens/initial_area/login.dart';
import 'package:sorttasks/screens/initial_area/register.dart';
import 'package:sorttasks/screens/user_area/History/task_history.dart';
import 'package:sorttasks/screens/user_area/List/task_list.dart';
import 'package:sorttasks/screens/user_area/Profile/profile_account_edit.dart';
import 'package:sorttasks/screens/user_area/Profile/profile_personal_edit.dart';
import 'package:sorttasks/screens/user_area/Profile/profile_view.dart';
import 'package:sorttasks/screens/user_area/main_screen.dart';
import 'package:sorttasks/screens/user_area/List/task_add.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const SorttasksApp(),
    ),
  );
}

class SorttasksApp extends StatelessWidget {
  const SorttasksApp({super.key});
  
  static bool isDarkTheme = false;
  static User? loggedInUser;

  static void setLoggedInUser(User? user) {
    loggedInUser = user;
  }

  // ignore: unused_element
  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logged Off'),
          content: const Text('You have logged off.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeNotifier>(context).isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/task_list': (context) => const TaskListScreen(),
        '/task_history': (context) => const TaskHistoryScreen(),
        '/task_add':(context) => const TaskAddScreen(),
        '/profile_view': (context) => const ProfileViewScreen(),
        '/profile_personal_edit': (context) => const ProfileUserEditScreen(),
        '/profile_account_edit': (context) => const ProfileAccountEditScreen(),
      },
    );
  }
}
