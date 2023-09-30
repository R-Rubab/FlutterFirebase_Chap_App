// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/Screens/home_screen.dart';
import 'package:flutter_chat_application_11/apis/apis_const.dart';
import 'package:flutter_chat_application_11/util/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool animationIcon = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        animationIcon = true;
      });
    });
  }

  _googleSignInButton() {
    Utils().showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await Apis.userExist())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await Apis.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
    // .then((value) {
    //   Utils().toastmsg('login');
    // }).onError((error, stackTrace) {
    //   Utils().toastmsg(error.toString());
    // });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // --------  Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // --------  Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // --------  Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // --------  Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n _signInWithGoogle: $e');
      Utils().toastmsg(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 242, 208, 248),
      appBar: AppBar(
        shadowColor: Colors.purple,
        title: const Text(
          'Welcome to Chat App',
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (_) => const HomeScreen()));
        //     },
        //     icon: const Icon(Icons.more_vert),
        //   )
        // ],
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: mq.height * 0.19,
            right: animationIcon ? mq.width * 0.3 : -mq.width * 0.44,
            width: mq.width * 0.44,
            child: const Image(
              image: AssetImage(
                'assets/images/icon1.png',
              ),
              width: 160,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            bottom: mq.height * 0.22,
            left: mq.width * 0.05,
            width: mq.width * 0.9,
            height: mq.height * 0.1,
            child: ElevatedButton.icon(
              onPressed: () {
                _googleSignInButton();
              },
              style: ElevatedButton.styleFrom(
                shadowColor: const Color.fromARGB(255, 164, 45, 185),
                elevation: 10,
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromARGB(255, 242, 208, 248),
                // backgroundColor: Colors.white,
              ),
              icon: Image(
                image: const AssetImage(
                  'assets/images/google.png',
                ),
                width: mq.width * 0.13,
              ),
              label: RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(text: 'sign in '),
                      TextSpan(
                          text: 'Google ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 22)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
