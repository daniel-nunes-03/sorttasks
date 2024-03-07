import 'package:flutter/material.dart';
import 'package:sorttasks/screens/initial_area/login.dart';
import 'package:sorttasks/screens/initial_area/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // Named Routes
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      }
    );
  }
}
