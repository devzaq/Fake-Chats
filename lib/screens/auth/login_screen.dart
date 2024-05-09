import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/main.dart';
import '../../helper/dialogs.dart';
import '/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleSignInWithGoogle() {
    Dialogs.showProgressbar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      log('\nUser: ${user!.user}');
      log('\nAdditionalInfo: ${user.additionalUserInfo}');

      if (await APIs.userExists()) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        APIs.createUser().then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle(): $e');
      Dialogs.showSnackbar(context, "no internet");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Welcome to Fake Chats",
            style: TextStyle(letterSpacing: 0.5, fontSize: 20),
          ),
        ),
        body: Stack(children: [
          AnimatedPositioned(
              top: mq.height * 0.15,
              width: mq.width * 0.50,
              right: _isAnimate ? mq.width * 0.25 : -mq.width * 0.5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/app_logo.png')),
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.1,
              width: mq.width * 0.8,
              height: mq.height * 0.06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    elevation: 1,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (_) => const HomeScreen()));
                    _handleSignInWithGoogle();
                  },
                  icon: Image.asset(
                    'images/google.png',
                    width: mq.width * 0.08,
                  ),
                  label: RichText(
                      text: const TextSpan(
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueGrey),
                          children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])))),
        ]));
  }
}
