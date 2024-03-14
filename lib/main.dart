import 'package:flutter/material.dart';
import 'package:sorttasks/screens/initial_area/login.dart';
import 'package:sorttasks/screens/initial_area/register.dart';
import 'package:sorttasks/screens/user_area/History/task_history.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SorttasksApp(),
    )
  );
}

class SorttasksApp extends StatelessWidget {
  const SorttasksApp({super.key});

  static bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // Named Routes
      routes: {
        '/': (context) => const TaskHistoryScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/task_history': (context) => const TaskHistoryScreen(),
      }
    );
  }
}
