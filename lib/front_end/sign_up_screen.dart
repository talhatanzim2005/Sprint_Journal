import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // Theme colors
  static const Color bgColor = Color(0xFF1B1B1A);
  static const Color cardColor = Color(0xFF252524);
  static const Color redColor = Color(0xFFCD0033);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,

        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 15),

                // ---------------- TITLE ----------------

                const Text(
                  'Create your account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter your information to get started.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 35),

                // ---------------- NAME ----------------

                const Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Enter your name',

                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),

                    prefixIcon: const Icon(
                      Icons.person_outline,
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

                const SizedBox(height: 20),

                // ---------------- EMAIL ----------------

                const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  keyboardType: TextInputType.emailAddress,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Enter your email',

                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
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

                const SizedBox(height: 20),

                // ---------------- PASSWORD ----------------

                const Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Create a password',

                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
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

                const SizedBox(height: 20),

                // ---------------- CONFIRM PASSWORD ----------------

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Confirm your password',

                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
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

                const SizedBox(height: 35),

                // ---------------- CREATE ACCOUNT BUTTON ----------------

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Account created successfully!',
                          ),
                        ),
                      );

                      // Go back to Sign In page
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- SIGN IN ----------------

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // Go back to Sign In page
                        Navigator.pop(context);
                      },

                      child: const Text(
                        'Sign In',
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
      ),
    );
  }
}