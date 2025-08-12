import '../data_model/PostModel.dart';
import '../data_model/SimpananPoin.dart';

class HomeData {
  List<PostModel> posts;
  SimpananPoin simpananPoin; // Menggunakan SimpananPoin sebagai tipe data

  HomeData({required this.posts, required this.simpananPoin});

  // Metode untuk membuat HomeData dari JSON
  factory HomeData.fromJson(Map<String, dynamic> json) {
    var list = json['posts'] as List;
    List<PostModel> postList = list.map((i) => PostModel.fromJson(i)).toList();

    return HomeData(
      posts: postList,
      simpananPoin: SimpananPoin.fromJson(json['simpanan_poin']),
    );
  }
}
