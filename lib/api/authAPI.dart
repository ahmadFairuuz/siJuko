import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ConfigAPI.dart';

class AuthApi {
  static final String REGIST_URL = Config.AUTH_URL + "register";
  static final String LOGIN_URL = Config.AUTH_URL + "login";

  static Future<Map<String, dynamic>> register(
    String nomorAnggota,
    String password,
    String username,
  ) async {
    var data = {
      'nomor_anggota': nomorAnggota,
      'password': password,
      'username': username,
    };

    final response = await http.post(Uri.parse(REGIST_URL), body: data);
    print(REGIST_URL);

    final Map<String, dynamic> responseData = json.decode(
      response.body.toString(),
    );

    print(response);
    return responseData;
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = {'username': username, 'password': password};

    final response = await http.post(Uri.parse(LOGIN_URL), body: data);

    final Map<String, dynamic> responseData = json.decode(
      response.body.toString(),
    );

    if (response.statusCode == 200) {
      sharedPreferences.setString('nama', responseData['data']['nama']);
      sharedPreferences.setString(
        'nomor_anggota',
        responseData['data']['nomor_anggota'],
      );
      sharedPreferences.setString('username', responseData['data']['username']);
      sharedPreferences.setString('jurusan', responseData['data']['jurusan']);
    }

    return responseData;
  }

  static Future<Map<String, dynamic>> reset_password(String password) async {
    final URL = Config.API_URL + "reset_password";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String username = sharedPreferences.getString('username')!;
    String nomor_anggota = sharedPreferences.getString('nomor_anggota')!;

    var data = {
      'username': username,
      'nomor_anggota': nomor_anggota,
      'password': password,
    };
    final response = await http.post(Uri.parse(URL), body: data);

    final Map<String, dynamic> responseData = json.decode(response.body);

    return responseData;
  }
}
