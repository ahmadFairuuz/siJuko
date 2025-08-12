import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data_model/HasilSurveyModel.dart';
import 'ConfigAPI.dart';


class HasilSurveyApi {
  static Future<List<HasilSurveyModel>> getHasilSurvey() async {
    final URL = Config.API_URL + 'hasil_survey';

    final response = await http.get(Uri.parse(URL));

    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var hasilSurvey = <HasilSurveyModel>[];
      print(response.body);
      if (response.statusCode == 200) {
        data['data'].forEach((v) {
          hasilSurvey.add(HasilSurveyModel.fromJson(v));
        });
      }
      return hasilSurvey;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
