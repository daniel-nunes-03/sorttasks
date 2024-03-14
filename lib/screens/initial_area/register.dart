import 'package:flutter/material.dart';
import 'package:sorttasks/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SorttasksApp.isDarkTheme ? Colors.black : Colors.white,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    SorttasksApp.isDarkTheme = !SorttasksApp.isDarkTheme;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SorttasksApp.isDarkTheme ? Colors.black : Colors.white,
                ),
                child: Icon(
                  SorttasksApp.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                  color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                  color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                  color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Text(
            'Sign Up',
            style: TextStyle(
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Sort your tasks easily for free with Sorttasks!',
            style: TextStyle(
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                    color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
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
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                    color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
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
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                    color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: SorttasksApp.isDarkTheme ? const Color.fromRGBO(128, 128, 128, 1) : Colors.black),
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
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Repeat Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Login logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SorttasksApp.isDarkTheme ? const Color.fromRGBO(0, 56, 255, 0.6) : const Color.fromRGBO(0, 56, 255, 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 22,
                      color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                      Icons.app_registration,
                      color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          ),
          const SizedBox(height: 50),
          Text(
            'Already have an account?',
            style: TextStyle(
              fontSize: 14,
              color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 180,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Register logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SorttasksApp.isDarkTheme ? const Color.fromRGBO(255, 155, 63, 0.8) : const Color.fromRGBO(255, 155, 63, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 22,
                      color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
                      Icons.login,
                      color: SorttasksApp.isDarkTheme ? Colors.white : Colors.black,
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
