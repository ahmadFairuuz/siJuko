import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data_model/HomeData.dart';
import '../data_model/PostModel.dart';
import '../data_model/SimpananPoin.dart';
import 'ConfigAPI.dart';

class GetPostPoin {
  static Future<HomeData> getHomeData() async {
    print('Masuk GetHomeData');

    // Mengambil data posts dan simpanan poin secara bersamaan
    final posts = await getPost();
    final simpananPoin = await getSimpananPoin();

    return HomeData(
      posts: posts,
      simpananPoin: SimpananPoin.fromJson(
        simpananPoin,
      ), // Memastikan simpananPoin adalah objek SimpananPoin
    );
  }

  static Future<Map<String, dynamic>> getSimpananPoin() async {
    final URL = '${Config.API_URL}get_simpanan_poin';

    SharedPreferences sPreferences = await SharedPreferences.getInstance();
    final nomorAnggota = sPreferences.getString('nomor_anggota');

    // Menggunakan POST request untuk mendapatkan simpanan poin
    final response = await http.post(
      Uri.parse(URL),
      body: {'nomor_anggota': nomorAnggota},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("🔥 DEBUG API SIMPANAN POIN:");
      print(data);
      return data['data']; // Mengembalikan data dari respons API
    }

    return {}; // Mengembalikan map kosong jika terjadi error
  }

  static Future<List<PostModel>> getPost({num page = 1}) async {
    print('Masuk getPost');

    final response = await http.get(
      Uri.parse(
        'https://kopmaunila.com/wp-json/wp/v2/posts?_embed&per_page=10&page=$page',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Mengonversi data menjadi list PostModel
      return data.map((v) => PostModel.fromJson(v)).toList();
    }

    return []; // Mengembalikan list kosong jika terjadi error
  }
}
