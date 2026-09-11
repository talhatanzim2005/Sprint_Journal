import 'dart:async';
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class OneTimeSplashScreen extends StatefulWidget {
  const OneTimeSplashScreen({super.key});

  @override
  State<OneTimeSplashScreen> createState() => _OneTimeSplashScreenState();
}

class _OneTimeSplashScreenState extends State<OneTimeSplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
        (){
        if(!mounted) return;

        Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
          );
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1A),

      body: Center(
        child: Image.asset(
            'assest/images/logo.jpg',
          height: 160,
          width: 160,

          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
