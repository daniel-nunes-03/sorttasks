import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';
import 'package:sorttasks/widgets/custom_appbar.dart';
import 'package:sorttasks/screens/user_area/History/task_history.dart';
import 'package:sorttasks/screens/user_area/List/task_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    TaskListScreen(),
    TaskHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color.fromRGBO(255, 153, 0, 1);
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: _selectedIndex == 0
                ? selectedColor
                : (isDarkTheme ? Colors.white : Colors.black),
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: _selectedIndex == 1
                ? selectedColor
                : (isDarkTheme ? Colors.white : Colors.black),
            ),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor,
        unselectedItemColor: isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme
          ? const Color.fromRGBO(17, 17, 17, 1)
          : const Color.fromRGBO(217, 217, 217, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
