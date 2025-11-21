import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jukover7/data_model/RiwayatBayar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ConfigAPI.dart';

class RiwayatApi {
  static Future<List<RiwayatBayar>> getRiwayat() async {
    final URL = '${Config.API_URL}history_pembayaran';

    SharedPreferences sPreferences = await SharedPreferences.getInstance();
    final nomorAnggota = sPreferences.getString('nomor_anggota');

    final response = await http.post(
      Uri.parse(URL),
      body: {'nomor_anggota': nomorAnggota},
    );

    if (response.body.isNotEmpty) {
      print(response.body);
      final Map<String, dynamic> data = jsonDecode(response.body);
      final riwayat = <RiwayatBayar>[];
      print("RESPONS RIWAYAT : ${response.body}");
      if (response.statusCode == 200) {
        print('DEBUG PEMBAYARAN SIMPANAN ✌️');
        print(data);
        data['data'].forEach((v) {
          riwayat.add(RiwayatBayar.fromJson(v));
        });
      }
      return riwayat;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
