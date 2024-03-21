import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/widgets/main_screen_appbar.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: isDarkTheme
          ? const Color.fromRGBO(45, 45, 45, 1)
          : Colors.white,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: isDarkTheme
                      ? const Color.fromRGBO(149, 149, 149, 1)
                      : const Color.fromRGBO(217, 217, 217, 1),
                    child: Icon(
                      Icons.person,
                      color: isDarkTheme ? Colors.white : Colors.black
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'FIRST NAME',
                    style: TextStyle(
                      fontSize: 22,
                      color: isDarkTheme ? Colors.white : Colors.black
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'LAST NAME',
                    style: TextStyle(
                      fontSize: 22,
                      color: isDarkTheme ? Colors.white : Colors.black
                    ),
                  ),
                  const SizedBox(height: 75),
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                      // Edit personal data logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 102, 255, 0.4) : const Color.fromRGBO(255, 168, 0, 0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 24
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Edit personal data',
                            style: TextStyle(
                              fontSize: 22,
                              color: isDarkTheme ? Colors.white : Colors.black,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                      // Edit personal data logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 102, 255, 0.4) : const Color.fromRGBO(255, 168, 0, 0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 24
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Edit personal data',
                            style: TextStyle(
                              fontSize: 22,
                              color: isDarkTheme ? Colors.white : Colors.black,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 75),
                  Text(
                    'Joined X years ago',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Total tasks created: X',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total tasks completed: X',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        backgroundColor: isDarkTheme
                          ? Colors.black
                          : const Color.fromRGBO(217, 217, 217, 1),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/main_screen');
                          },
                          // Important to make it zero inside the button so it gets centered
                          // instead of inheriting the padding from the positioning of the avatar
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        backgroundColor: isDarkTheme
                          ? const Color.fromRGBO(255, 0, 0, 0.7)
                          : Colors.red,
                        child: TextButton(
                          onPressed: () {
                            // Logout logic
                            // Temporary: back to login routing
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          // Important to make it zero inside the button so it gets centered
                          // instead of inheriting the padding from the positioning of the avatar
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(
                            Icons.logout,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
