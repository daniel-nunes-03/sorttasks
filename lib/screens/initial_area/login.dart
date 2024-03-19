import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sorttasks/classes/theme_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeNotifier>(context).isDarkTheme;
    
    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkTheme ? Colors.black : Colors.white,
                ),
                child: Icon(
                  isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkTheme ? Colors.white : Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sorttasks',
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 50,
                height: 50,
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
          const SizedBox(height: 70),
          Text(
            'Welcome!',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please sign in to continue',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.key,
                          color: isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 180,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Login logic
                Navigator.pushReplacementNamed(context, '/main_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme ? const Color.fromRGBO(0, 56, 255, 0.6) : const Color.fromRGBO(0, 56, 255, 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    )
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.login,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: 14,
              color: isDarkTheme ? Colors.white : Colors.black,
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 190,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Recover password logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme ? const Color.fromRGBO(255, 80, 80, 0.8) : const Color.fromRGBO(255, 198, 198, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Recover it here',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    )
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_center,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'No account? Register here:',
            style: TextStyle(
              fontSize: 14,
              color: isDarkTheme ? Colors.white : Colors.black,
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Go to register page logic
                Navigator.pushReplacementNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme ? const Color.fromRGBO(255, 155, 63, 0.8) : const Color.fromRGBO(255, 155, 63, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      fontSize: 22,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    )
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.app_registration,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          )
        ],
      ),
    );
  }
}
