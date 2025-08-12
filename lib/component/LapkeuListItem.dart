import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_model/LapkeuModel.dart';
import '../screen/PdfViewScreen.dart'; // Pastikan Anda mengimpor PdfViewScreen

class LaporanKeuanganItem extends StatelessWidget {
  final LaporanKeuanganModel dataLaporan;
  DateFormat dateFormat = DateFormat('MMMM yyyy');

  LaporanKeuanganItem({Key? key, required this.dataLaporan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigasi ke PdfViewScreen dan mengirimkan link PDF
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewScreen(
                url: dataLaporan.link,
              ), // Kirimkan URL ke PdfViewScreen
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(
            vertical: 8,
          ), // Menambahkan jarak vertikal antar item
          decoration: BoxDecoration(
            color: Colors.green[900], // Warna latar belakang
            borderRadius: BorderRadius.circular(
              10,
            ), // Menambahkan sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4), // Posisi bayangan
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/image/pdf.png",
                fit: BoxFit.contain,
                width: 50,
              ),
              const SizedBox(width: 10),
              Expanded(
                // Menggunakan Expanded untuk mengatur ruang di dalam Row
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataLaporan.judul.length >= 30
                          ? dataLaporan.judul.substring(0, 30) + '...'
                          : dataLaporan.judul,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8), // Jarak antar judul dan tanggal
                    Text(
                      () {
                        try {
                          String tahun = dataLaporan.tahun;
                          String bulan = dataLaporan.bulan.padLeft(
                            2,
                            '0',
                          ); // Menambahkan nol di depan jika bulan satu digit
                          String tanggalString = '${tahun}-${bulan}-01';
                          DateTime tanggal = DateTime.parse(tanggalString);
                          return dateFormat.format(tanggal);
                        } catch (e) {
                          print('Error parsing date: $e');
                          return 'Invalid date'; // Menangani error dengan pesan default
                        }
                      }(),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
