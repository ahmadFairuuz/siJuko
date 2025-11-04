import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/ConfigAPI.dart';
import '../data_model/LapkeuModel.dart';

class LaporanKeuanganApi {
  static Future<List<LaporanKeuanganModel>> getLaporanKeuangan({
    int page = 1,
    int limit = 10,
  }) async {
    final String URL =
        '${Config.API_URL}laporan_keuangan?page=$page&limit=$limit';

    final response = await http.get(Uri.parse(URL));
    print(response.body);
    if (response.body.isNotEmpty) {
      print('masuk sini');
      Map<String, dynamic> data = jsonDecode(response.body);
      var list = <LaporanKeuanganModel>[];
      if (response.statusCode == 200) {
        print('ada datanya');
        data['data'].forEach((v) {
          list.add(LaporanKeuanganModel.fromJson(v));
        });
      }
      return list;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
