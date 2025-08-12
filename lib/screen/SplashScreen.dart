import 'package:flutter/material.dart';

import 'WelcomeScreen.dart'; // Import WelcomeScreen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menampilkan logo selama 5 detik
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/image/juko_merah.png',
          width: 150,
        ), // Ganti dengan asset logo yang sesuai
      ),
    );
  }
}
