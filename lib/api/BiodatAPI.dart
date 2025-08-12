import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ConfigAPI.dart';
import '../data_model/BiodataModel.dart';

class BiodataApi {
  static Future<BiodataModel> getBiodata() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    var nomorAnggota = sPref.getString('nomor_anggota');
    final BIODATA_URL =
        Config.API_URL + "get_biodata?nomor_anggota=${nomorAnggota}";

    var response = await http.get(Uri.parse(BIODATA_URL));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return BiodataModel.fromJson(data['data']);
    } else {
      throw Exception('Gagal mendapatkan biodata');
    }
  }

  static Future<Map<String, dynamic>> updateBiodata(
    BiodataModel biodataModel,
  ) async {
    final UPDATE_BIO = Config.API_URL + "update_biodata";
    var data = biodataModel.toJson(biodataModel);
    print(data);

    var response = await http.post(Uri.parse(UPDATE_BIO), body: data);
    // var response = await http.post(
    //   Uri.parse(UPDATE_BIO),
    //   body: data,
    // );

    if (response.body != null) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal mengupdate biodata');
    }
  }
}
