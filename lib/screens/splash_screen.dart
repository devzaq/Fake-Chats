import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messages/api/apis.dart';
import 'package:messages/screens/auth/login_screen.dart';
import 'package:messages/screens/home_screen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top]);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark));
      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Positioned(
            width: mq.width * 0.5,
            right: mq.width * 0.25,
            bottom: mq.height * 0.6,
            child: const CircleAvatar(
              backgroundImage: AssetImage("images/fakeSplashScreen.png"),
              radius: 100,
            ),
          ),
          Positioned(
            bottom: mq.height * 0.15,
            width: mq.width,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            backgroundColor: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    children: const [
                      TextSpan(text: 'Fake'),
                      TextSpan(
                          text: 'Chats',
                          style: TextStyle(
                              backgroundColor: Colors.amber,
                              color: Colors.black,
                              wordSpacing: 1))
                    ])),
          )
        ],
      ),
    );
  }
}
