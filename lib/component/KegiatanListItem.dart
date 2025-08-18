import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_model/KegiatanModel.dart';

class KegiatanItem extends StatelessWidget {
  final KegiatanModel dataKegiatan;
  DateFormat dateFormat = DateFormat('dd MMMM yyyy');

  KegiatanItem({super.key, required this.dataKegiatan});

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(dataKegiatan.tanggal_kegiatan);
    var dateLeft = (date.difference(DateTime.now()).inDays + 1);
    var isAfter = date.isAfter(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // Jarak antar kotak
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green[900], // Latar belakang hijau
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.15,
              ), // Warna bayangan dengan transparansi
              spreadRadius: 2, // Menambah ukuran shadow
              blurRadius: 6, // Mengaburkan shadow agar lebih lembut
              offset: Offset(0, 4), // Mengatur posisi bayangan
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    dataKegiatan.nama_kegiatan,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Teks terpotong dengan "..."
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 80,
                  ), // Batas maksimum lebar label
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // Latar belakang putih untuk label hari
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 8,
                  ),
                  child: Text(
                    dateLeft > 1
                        ? '$dateLeft hari lagi'
                        : (isAfter ? 'Besok' : 'Hari ini'),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.green[900],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dataKegiatan.tempat_kegiatan,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black, // Warna teks hijau tua
                    fontSize: 14, // Ukuran teks lebih kecil
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dateFormat.format(
                    DateTime.parse(dataKegiatan.tanggal_kegiatan),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
