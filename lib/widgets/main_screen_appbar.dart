import 'package:flutter/material.dart';
import 'package:sorttasks/main.dart';

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
    return AppBar(
      backgroundColor: SorttasksApp.isDarkTheme
        ? const Color.fromRGBO(17, 17, 17, 1)
        : const Color.fromRGBO(217, 217, 217, 1),
      leading: Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                SorttasksApp.isDarkTheme = !SorttasksApp.isDarkTheme;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SorttasksApp.isDarkTheme
                ? const Color.fromRGBO(17, 17, 17, 1)
                : const Color.fromRGBO(217, 217, 217, 1),
            ),
            child: Icon(
              SorttasksApp.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SorttasksApp.isDarkTheme
                  ? const Color.fromRGBO(17, 17, 17, 1)
                  : const Color.fromRGBO(217, 217, 217, 1),
              ),
              child: Icon(
                Icons.person,
                color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                size: 25,
              ),
            ),
          ],
        )
      ],
    );
  }
}
