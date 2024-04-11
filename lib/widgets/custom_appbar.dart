import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return AppBar(
      backgroundColor: isDarkTheme
        ? const Color.fromRGBO(17, 17, 17, 1)
        : const Color.fromRGBO(217, 217, 217, 1),
      leading: Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkTheme
                ? const Color.fromRGBO(17, 17, 17, 1)
                : const Color.fromRGBO(217, 217, 217, 1),
            ),
            child: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: isDarkTheme ? Colors.white : Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sorttasks',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 22,
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task,
              color: isDarkTheme ? Colors.white : Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                // Profile Screen transition logic
                Navigator.pushReplacementNamed(context, '/profile_view');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme
                  ? const Color.fromRGBO(17, 17, 17, 1)
                  : const Color.fromRGBO(217, 217, 217, 1),
              ),
              child: Icon(
                Icons.person,
                color: isDarkTheme ? Colors.white : Colors.black,
                size: 25,
              ),
            ),
          ],
        )
      ],
    );
  }
}
