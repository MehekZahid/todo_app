// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, annotate_overrides, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:todo_app/UI/Auth/home_screen/home_sreen.dart';
import 'package:todo_app/UI/Auth/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    moveNextScreen();
  }

  void moveNextScreen() {
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(seconds: 5), () {
      print('user: $user');
      if (user == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 183, 24, 12),
                    const Color.fromARGB(255, 147, 18, 9),
                    const Color.fromARGB(255, 97, 12, 6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/todo.png',
                    height: 300.h,
                    width: double.infinity,
                  ),
                  Text(
                    'Y0ur\'s Tod0',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Ubuntu',
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
