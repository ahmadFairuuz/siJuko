import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jukover7/data_model/RiwayatBayar.dart';

class Riwayatlist extends StatelessWidget {
  final RiwayatBayar dataRiwayat;
  DateFormat dateFormat = DateFormat('HH:mm • dd/MM/yyyy ');

  Riwayatlist({super.key, required this.dataRiwayat});

  String getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Menunggu';
      case '2':
        return 'Ditolak';
      case '3':
        return 'Diterima';
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case '1':
        return Colors.orange;
      case '2':
        return Colors.red;
      case '3':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(dataRiwayat.waktuPembayaran);

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
                    dataRiwayat.namaLengkap,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                  ), // Batas maksimum lebar label
                  decoration: BoxDecoration(
                    color: getStatusColor(dataRiwayat.status),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 8,
                  ),
                  child: Text(
                    getStatusText(dataRiwayat.status),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nominal: Rp. ${dataRiwayat.nominal}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 5), // jarak

                      Text(
                        'Denda: Rp. ${dataRiwayat.denda ?? "0"}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white70, // sedikit lebih soft
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  dateFormat.format(
                    DateTime.parse(dataRiwayat.waktuPembayaran),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.white,
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
