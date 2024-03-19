import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/screens/initial_area/login.dart';
import 'package:sorttasks/screens/initial_area/register.dart';
import 'package:sorttasks/screens/user_area/History/task_history.dart';
import 'package:sorttasks/screens/user_area/List/task_list.dart';
import 'package:sorttasks/screens/user_area/Profile/profile_view.dart';
import 'package:sorttasks/screens/user_area/main_screen.dart';

void main() {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeNotifier>(context).isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main_screen': (context) => const MainScreen(),
        '/task_list': (context) => const TaskListScreen(),
        '/task_history': (context) => const TaskHistoryScreen(),
        '/profile_view': (context) => const ProfileViewScreen(),
      },
    );
  }
}
