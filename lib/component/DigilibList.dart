import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan mengimpor Google Fonts

import '../data_model/DigilibModel.dart';

class DigilibListItem extends StatelessWidget {
  final DigilibModel dataDigilib;
  DateFormat dateFormat = DateFormat('dd MMMM');

  DigilibListItem({super.key, required this.dataDigilib});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (!await launchUrl(Uri.parse(dataDigilib.file))) {
            throw Exception('Could not launch ${dataDigilib.file}');
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 8), // Jarak antar item
          decoration: BoxDecoration(
            color: Colors.green[900], // Warna latar belakang
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
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
                'assets/image/pdf.png',
                fit: BoxFit.contain,
                width: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                // Menggunakan Expanded untuk mengatur ruang di dalam Row
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: dataDigilib.judul,
                      child: Text(
                        dataDigilib.judul,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ), // Jarak antar judul dan deskripsi
                    Tooltip(
                      message: dataDigilib.deskripsi,
                      child: Text(
                        dataDigilib.deskripsi,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Colors.white70,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // otomatis potong jadi "..."
                        maxLines: 2, // biar hanya 1 baris
                        softWrap: false, // jangan turun ke baris berikutnya
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
