import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkTheme = themeNotifier.isDarkTheme;
        return AppBar(
          // This makes the background color of the appbar to stay consistent
          // in any screens with scrollbars that have been scrolled down
          scrolledUnderElevation: 0.0,
          backgroundColor: isDarkTheme
            ? const Color.fromARGB(255, 17, 17, 17)
            : const Color.fromARGB(255, 217, 217, 217),
          leading: TextButton(
            onPressed: () {
              themeNotifier.toggleTheme();
            },
            style: TextButton.styleFrom(
              backgroundColor: isDarkTheme
                  ? const Color.fromARGB(255, 17, 17, 17)
                  : const Color.fromARGB(255, 217, 217, 217),
            ),
            child: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: isDarkTheme ? Colors.white : Colors.black,
              size: 25,
            ),  
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
            TextButton(
              onPressed: () {
                // Profile Screen transition logic
                Navigator.pushReplacementNamed(context, '/profile_view');
              },
              style: TextButton.styleFrom(
                backgroundColor: isDarkTheme
                  ? const Color.fromARGB(255, 17, 17, 17)
                  : const Color.fromARGB(255, 217, 217, 217),
              ),
              child: Icon(
                Icons.person,
                color: isDarkTheme ? Colors.white : Colors.black,
                size: 25,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
