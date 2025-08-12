import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api/ConfigAPI.dart';
import '../data_model/SurveyModel.dart';

class SurveyApi {
  static Future<List<SurveyModel>> getSurvey() async {
    final URL = Config.API_URL + 'survey_berjalan';

    final response = await http.get(Uri.parse(URL));
    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      var survey = <SurveyModel>[];
      if (response.statusCode == 200) {
        data['data'].forEach((v) {
          survey.add(SurveyModel.fromJson(v));
        });
      }
      return survey;
    }else{
      throw Exception('Failed to load data');
    }
  }
}
