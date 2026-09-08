import 'package:flutter/material.dart';
import 'sign_up_screen.dart';
import 'main_dashboard_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const Color bgColor = Color(0xFF1B1B1A);
  static const Color cardColor = Color(0xFF252524);
  static const Color redColor = Color(0xFFCD0033);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // App name
              const Text(
                'SprintJournal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Welcome text
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              // Email field
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),

                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),

                  filled: true,
                  fillColor: cardColor,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Password field
              TextField(
                obscureText: true,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),

                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.white70,
                  ),

                  filled: true,
                  fillColor: cardColor,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {

                    // Go to Main Dashboard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const MainDashboardScreen(),
                      ),
                    );

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Sign Up section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  TextButton(
                    onPressed: () {

                      // Open Sign Up page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SignUpScreen(),
                        ),
                      );

                    },

                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}