import 'package:flutter/material.dart';
import 'main_dashboard_screen.dart';

class SignInScreen extends StatelessWidget{
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1A),
      body: Center(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SprintJournal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 35),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Color(0xFF252524),
                  filled: true,
                ),
              ),
              const  SizedBox(height:15),
              const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Color(0xFF252524),
                  filled: true,
                ),
              ),
              const SizedBox(height:25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0033),
                  foregroundColor: Colors.white,
                ),
                  onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainDashboardScreen(),
                    ),
                  );
                  },
                  child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}