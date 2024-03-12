import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sorttasks',
                style: TextStyle(
                  color: Colors.black,
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
                child: const Icon(
                  Icons.task,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          const Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please sign in to continue',
            style: TextStyle(
              color: Colors.black,
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.key,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 56, 255, 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    )
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.login,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          ),
          const SizedBox(height: 50),
          const Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black
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
                backgroundColor: const Color.fromRGBO(255, 198, 198, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Recover it here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_center,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              )                
            ),
          ),
          const SizedBox(height: 50),
          const Text(
            'No account? Register here:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 300,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Register logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 155, 63, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    )
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.app_registration,
                      color: Colors.black,
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
