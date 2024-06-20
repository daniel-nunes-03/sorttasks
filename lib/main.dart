import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorttasks/classes/notification_controller.dart';
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
import 'package:sorttasks/services/background_service.dart' as background_service;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult[0] == ConnectivityResult.none) {
    runApp(const NoInternetApp());
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notifications are only sent if the user has checked the "Remember Me" checkbox
  background_service.initializeService();

  bool isLoggedIn = false;

  final prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('sorttasks_email');
  final String? password = prefs.getString('sorttasks_password');

  if (email != null && password != null) {
    isLoggedIn = await FirestoreUtils.login(email, password);
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Sorttasks(
        initialRoute: isLoggedIn ? '/main_screen' : '/login',
      ),
    ),
  );
}

class Sorttasks extends StatefulWidget {
  const Sorttasks({
    super.key,
    required this.initialRoute,
  });

  final String initialRoute;

  @override
  State<Sorttasks> createState() => SorttasksApp();
}

class SorttasksApp extends State<Sorttasks> {  
  static bool isDarkTheme = false;
  static User? loggedInUser;

  static void setLoggedInUser(User? user) {
    loggedInUser = user;
  }

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.initialRoute,
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

class NoInternetApp extends StatelessWidget {
  const NoInternetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('No Internet Connection'),
        ),
        body: const Center(
          child: Text('Please check your internet connection and try again.'),
        ),
      ),
    );
  }
}
