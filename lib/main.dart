import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/firebase/firestore_utils.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isLoggedIn = false;

  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('email');
  final String? password = prefs.getString('password');

  if (email != null && password != null) {
    isLoggedIn = await FirestoreUtils.login(email, password);
  }

  // Check tasks every minute
  const Duration checkInterval = Duration(minutes: 1);
  Timer.periodic(checkInterval, (Timer timer) async {
    // Function to check tasks due within 3 days
    await FirestoreUtils.checkTasksDueWithin3Days();
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: SorttasksApp(
        initialRoute: isLoggedIn ? '/main_screen' : '/login',
      ),
    ),
  );
}

class SorttasksApp extends StatelessWidget {
  const SorttasksApp({
    super.key,
    required this.initialRoute,
  });

  final String initialRoute;
  
  static bool isDarkTheme = false;
  static User? loggedInUser;

  static void setLoggedInUser(User? user) {
    loggedInUser = user;
  }

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      home: const LoginScreen(),
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
