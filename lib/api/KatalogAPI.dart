import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data_model/KatalogModel.dart';
import 'ConfigAPI.dart';

class KatalogApi {
  static Future<List<KatalogModel>> getKatalog() async {
    final URL = Config.API_URL + 'produk_usaha';

    final response = await http.get(Uri.parse(URL));

    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var katalog = <KatalogModel>[];
      if (response.statusCode == 200) {
        print('masuk 200');
        data['data'].forEach((v) {
          katalog.add(KatalogModel.fromJson(v));
        });
      }
      return katalog;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
