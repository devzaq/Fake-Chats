import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/splash_screen.dart';
import 'firebase_options.dart';

late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fake Chats',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Theme.of(context).colorScheme.primary),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: GoogleFonts.blackOpsOne(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                // fontSize: 100.0,
              )),
              backgroundColor: Colors.transparent,
              elevation: 1,
              iconTheme: const IconThemeData(color: Colors.black))),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
