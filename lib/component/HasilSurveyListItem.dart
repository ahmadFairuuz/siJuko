import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data_model/HasilSurveyModel.dart';

class HasilSurveyListItem extends StatelessWidget {
  final HasilSurveyModel dataLaporan;
  DateFormat dateFormat = DateFormat('dd MMMM yyyy'); // Format tanggal

  HasilSurveyListItem({Key? key, required this.dataLaporan}) : super(key: key);

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(dataLaporan.file))) {
      throw Exception('Could not launch ${dataLaporan.file}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _launchUrl,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.green[900], // Menggunakan warna hijau [900]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/image/survey.png",
                fit: BoxFit.contain,
                width: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dataLaporan.nama_survey.length >= 30
                          ? dataLaporan.nama_survey.substring(0, 30) + '...'
                          : dataLaporan.nama_survey,
                      maxLines: 2,
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
                      dateFormat.format(DateTime.parse(dataLaporan.tgl_mulai)) +
                          ' - ' +
                          dateFormat.format(
                            DateTime.parse(dataLaporan.tgl_selesai),
                          ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ), // Ikon untuk menunjukkan navigasi
            ],
          ),
        ),
      ),
    );
  }
}
