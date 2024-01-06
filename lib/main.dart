import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_application_11/Screens/chat_screen.dart';
import 'package:flutter_chat_application_11/Screens/home_screen.dart';
import 'package:flutter_chat_application_11/auth/login.dart';
import 'package:flutter_chat_application_11/auth/splash_screen.dart';
import 'package:flutter_chat_application_11/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter chat app',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            // textTheme: const TextTheme(titleMedium: TextStyle(fontSize: 22)),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 10,
              // iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 29),
              // backgroundColor: Colors.white,
            )),
        // home: const SplashScreen(),
        home: const LoginScreen());
  }
}
