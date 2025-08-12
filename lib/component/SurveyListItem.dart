import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data_model/SurveyModel.dart';

class SurveyListItem extends StatelessWidget {
  final SurveyModel dataSurvey;
  DateFormat dateFormat = DateFormat('dd MMMM yyyy');

  SurveyListItem({Key? key, required this.dataSurvey}) : super(key: key);

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(dataSurvey.link))) {
      throw Exception('Could not launch ${dataSurvey.link}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _launchUrl();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green[900], // Mengatur warna latar belakang
            border: Border.all(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/image/survey.png", // Gambar ikon survei
                fit: BoxFit.cover,
                width: 40, // Sesuaikan ukuran gambar
              ),
              const SizedBox(width: 15), // Jarak antara gambar dan teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataSurvey.nama_survey.length >= 30
                          ? dataSurvey.nama_survey.substring(0, 30) + '...'
                          : dataSurvey.nama_survey,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dateFormat.format(DateTime.parse(dataSurvey.tgl_mulai)) +
                          ' - ' +
                          dateFormat.format(
                            DateTime.parse(dataSurvey.tgl_selesai),
                          ),
                      style: const TextStyle(
                        color: Colors
                            .white70, // Mengubah warna tanggal menjadi lebih terang
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Tambahkan deskripsi atau informasi tambahan di sini
                    Text(
                      'Klik untuk mengisi survei', // Informasi tambahan
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54, // Warna informasi tambahan
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
