import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ConfigAPI.dart';
import '../data_model/BiodataModel.dart';

class BiodataApi {
  static Future<BiodataModel> getBiodata() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    var nomorAnggota = sPref.getString('nomor_anggota');
    final biodataUrl =
        "${Config.API_URL}get_biodata?nomor_anggota=$nomorAnggota";

    var response = await http.get(Uri.parse(biodataUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return BiodataModel.fromJson(responseData['data']);
    } else {
      throw Exception('Gagal mendapatkan biodata');
    }
  }

  static Future<Map<String, dynamic>> updateBiodata(
    BiodataModel biodataModel,
  ) async {
    final updateBio = "${Config.API_URL}update_biodata";
    var requestData = biodataModel.toJson(biodataModel);
    print(requestData);

    var response = await http.post(Uri.parse(updateBio), body: requestData);

    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  }
}
