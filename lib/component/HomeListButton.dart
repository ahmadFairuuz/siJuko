import 'package:flutter/material.dart';

import '../screen/KegiatanScreen.dart';
/*import '../screen/HasilSurveyScreen.dart';
import '../screen/KatalogScreen.dart';
import '../screen/DigilibScreen.dart'; // Impor DigilibScreen
import '../screen/LapkeuScreen.dart'; // Pastikan mengimpor LapkeuScreen
import '../screen/SurveyScreen.dart'; // Impor SurveyScreen*/

class HomeListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Membungkus seluruh konten agar bisa digulir
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(
          14,
          8,
          16,
          27,
        ), // Menambah padding di atas, mengurangi di bawah
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // Posisi bayangan
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 3, // Menyusun dalam 3 kolom
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Menonaktifkan menggulir di GridView
          mainAxisSpacing: 16, // Mengurangi jarak antar baris
          crossAxisSpacing: 16, // Jarak antar kolom
          children: [
            buildMenuItem(context, Icons.calendar_today, 'Kegiatan Terdekat'),
            buildMenuItem(context, Icons.bar_chart, 'Laporan Keuangan'),
            buildMenuItem(context, Icons.library_books, 'Digital Library'),
            buildMenuItem(context, Icons.map, 'Survey Berjalan'),
            buildMenuItem(context, Icons.check_circle, 'Hasil Survey'),
            buildMenuItem(context, Icons.business, 'Produk Usaha'),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Kegiatan Terdekat') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
          );
        } else if (label == 'Laporan Keuangan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
            // MaterialPageRoute(builder: (context) => LaporanKeuanganScreen()),
          );
        } else if (label == 'Digital Library') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
            /*MaterialPageRoute(
              builder: (context) => DigilibScreen(),
            ),*/
          );
        } else if (label == 'Survey Berjalan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
            /* MaterialPageRoute(
              builder: (context) => SurveyScreen(),
            ),*/
          );
        } else if (label == 'Hasil Survey') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
            /*MaterialPageRoute(builder: (context) => HasilSurveyScreen()),*/
          );
        } else if (label == 'Produk Usaha') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KegiatanScreen()),
            /* MaterialPageRoute(builder: (context) => KatalogScreen()),*/
          );
        }

        // Anda bisa menambahkan tindakan lain untuk label berbeda di sini
      },
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Menaruh konten di bagian atas
        children: [
          // Lingkaran dengan ikon di dalamnya
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade50, // Warna latar lingkaran
            ),
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: Colors.green[900], // Warna ikon
              ),
            ),
          ),
          SizedBox(height: 4), // Mengurangi jarak antara ikon dan teks
          // Teks di bawah ikon
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
