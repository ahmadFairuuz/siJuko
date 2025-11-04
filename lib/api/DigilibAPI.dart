import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/ConfigAPI.dart';
import '../data_model/DigilibModel.dart';

class DigilibApi {
  static Future<List<DigilibModel>> getDigilib({
    int page = 1,
    int limit = 10,
  }) async {
    final URL = '${Config.API_URL}digilib?page=$page&limit=$limit';

    final response = await http.get(Uri.parse(URL));

    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var digitalLibrary = <DigilibModel>[];
      print(response.body);
      if (response.statusCode == 200) {
        data['data'].forEach((v) {
          digitalLibrary.add(DigilibModel.fromJson(v));
        });
      }
      return digitalLibrary;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
