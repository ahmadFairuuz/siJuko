import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/ConfigAPI.dart';

class PresensiApi {
  static Future<Map<String, dynamic>> presensi(String id) async {
    final URL = Config.API_URL + 'presensi';

    SharedPreferences sPref = await SharedPreferences.getInstance();
    var nomor_anggota = sPref.getString('nomor_anggota');

    var body = {
      'id_kegiatan': id,
      'nomor_anggota': nomor_anggota.toString(),
    };

    final response = await http.post(
      Uri.parse(URL),
      body: body,
    );
    Map<String, dynamic> data = {};

    if (response.body.isNotEmpty) {
      data = jsonDecode(response.body);
    }

    return data;
  }
}
