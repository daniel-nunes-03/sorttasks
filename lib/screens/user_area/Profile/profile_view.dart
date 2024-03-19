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
      body: Center(
        child: Column(
          children: [
            const Text(
              'PROFILE'
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main_screen');
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkTheme
                ? const Color.fromRGBO(17, 17, 17, 1)
                : const Color.fromRGBO(217, 217, 217, 1),
            ),
            child: Icon(
              Icons.arrow_back,
              color: isDarkTheme ? Colors.white : Colors.black,
              size: 25,
            ),
          ),
          ],
        )
      )
    );
  }
}
