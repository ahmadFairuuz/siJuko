//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:tesjuko/api/FirebaseAPI.dart';
//import 'package:tesjuko/screen/HomeScreen.dart';
import 'package:jukover7/screen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
