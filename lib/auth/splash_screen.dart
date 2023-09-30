import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_application_11/apis/apis_const.dart';

import '../Screens/home_screen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      if (Apis.auth.currentUser != null) {
        log('*** ${Apis.auth.currentUser}');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: mq.height * 0.19,
            right: mq.width * 0.3,
            width: mq.width * 0.44,
            child: const Image(
              image: AssetImage(
                'assets/images/icon1.png',
              ),
              width: 160,
            ),
          ),
          Positioned(
            bottom: mq.height * 0.3,
            width: mq.width,
            child: const Text(
              textAlign: TextAlign.center,
              'MADE BY AISH WITH 💜',
              style: TextStyle(
                  fontSize: 27,
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(255, 102, 5, 119),
                      offset: Offset(5, 5),
                      blurRadius: 5,
                    ),
                  ],
                  color: Color.fromARGB(255, 239, 239, 239),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
