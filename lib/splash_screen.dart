import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:susubox/auth/register_screen.dart';
import 'package:susubox/auth/welcome_screen.dart';
import 'package:susubox/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen())
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
               padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 33.w),
               width: 80.w,
               height: 70.h,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(15),
                 color: buttonColor
               ),
               child: Container(
                 height: 30.h,
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Colors.white
                 ),
               ),
             )
          ],
        ),
      ),
    ));
  }
}
