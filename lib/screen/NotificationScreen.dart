import 'package:flutter/material.dart';

import '../component/BottomNavigation.dart'; // Import BottomNavigation
import '../data_model/HomeData.dart'; // Import HomeData

class NotificationScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Future<HomeData> homeData;

  const NotificationScreen({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.homeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white, // Latar belakang putih
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Judul Notifikasi di tengah atas
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Notifikasi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ),
            const SizedBox(height: 40), // Jarak antara judul dan gambar
            // Gambar logo
            Image.asset(
              'assets/image/juko_merah.png', // Ganti dengan path gambar logo Anda
              width: 150, // Atur ukuran sesuai kebutuhan
              height: 150,
            ),
            const SizedBox(height: 20), // Jarak antara gambar dan teks
            // Teks penjelasan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Halo coopers!, notifikasi yang kamu terima akan disimpan disini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
        homeData: homeData,
      ),
    );
  }
}
