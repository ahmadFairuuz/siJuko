import 'package:flutter/material.dart';
import 'package:jukover7/screen/DaftarScreen.dart';
import 'package:jukover7/screen/LoginScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: -100, // Menggeser gambar ke kanan, sebagian keluar layar
              top: 0,
              bottom: 200,
              child: Image.asset(
                "assets/image/juko_merah.png",
                width: MediaQuery.of(context).size.width * 0.9, // 90% lebar layar
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 16,
              top: MediaQuery.of(context).size.height * 0.3, // Menyesuaikan posisi vertikal teks
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5, // Lebar maksimum teks
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black, // Warna teks default
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "Halo "), // Teks biasa
                          TextSpan(
                            text: "Coopers!", // Teks dengan warna berbeda
                            style: TextStyle(color: Colors.green[900]), // Warna hijau untuk "Coopers"
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left, // Menyelaraskan teks ke kiri
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Colors.black, // Warna teks default
                        ),
                        children: <TextSpan>[
                          TextSpan(text: "Selamat datang di\nAplikasi "), // Teks biasa
                          TextSpan(
                            text: "Si Juko", // Teks dengan warna berbeda
                            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold), // Warna hijau untuk "Si Juko"
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center, // Menyelaraskan teks ke tengah
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        _noAnimationRoute(DaftarScreen()), // Pindah ke halaman Daftar tanpa animasi
                      );
                    },
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        fontFamily: 'Poppins', // Menggunakan font Poppins
                        fontSize: 16,
                        color: Colors.white, // Warna teks tombol
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      minimumSize: Size(200, 40), // Mengurangi panjang shape tombol
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        _noAnimationRoute(LoginScreen()), // Pindah ke halaman Login tanpa animasi
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Poppins', // Menggunakan font Poppins
                        fontSize: 16,
                        color: Colors.white, // Warna teks tombol
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green[900], backgroundColor: Colors.green[900],
                      side: BorderSide(color: Colors.green),
                      minimumSize: Size(200, 40), // Mengurangi panjang shape tombol
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk berpindah halaman tanpa animasi transisi
  Route _noAnimationRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero, // Menghapus animasi transisi
      reverseTransitionDuration: Duration.zero, // Menghapus animasi transisi saat kembali
    );
  }
}
