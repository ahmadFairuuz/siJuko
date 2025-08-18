import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/ConfigAPI.dart';
import '../data_model/KegiatanModel.dart';

class KegiatanApi {
  static Future<List<KegiatanModel>> getKegiatan() async {
    final kegiatanUrl = "${Config.API_URL}get_kegiatan";
    var response = await http.get(Uri.parse(kegiatanUrl));
    if (response.body.isNotEmpty) {
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      final kegiatan = <KegiatanModel>[];
      if (response.statusCode == 200) {
        data['data'].forEach((v) {
          kegiatan.add(KegiatanModel.fromJson(v));
        });
      }

      return kegiatan;
    } else {
      throw Exception('Gagal mendapatkan kegiatan');
    }
  }
}
