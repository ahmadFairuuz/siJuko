import 'package:html/parser.dart';

class PostModel {
  String title;
  String content;
  String date;
  String author;
  String imageUrl;

  PostModel({
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    required this.imageUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Menggunakan 'html' untuk menghindari karakter HTML
    String parsedTitle =
        parse(json['title']['rendered']).documentElement?.text ?? '';
    String parsedContent =
        parse(json['content']['rendered']).documentElement?.text ?? '';

    return PostModel(
      title: parsedTitle,
      content: parsedContent,
      date: json['date'],
      author:
          json['_embedded']['author'][0]['name'] ??
          'Teknologi Kopma Unila', // Menambahkan default 'Unknown'
      imageUrl:
          json['_embedded']?['wp:featuredmedia']?[0]?['media_details']?['sizes']?['thumbnail']?['source_url'] ??
          json['_embedded']?['wp:featuredmedia']?[0]?['source_url'] // fallback jika thumbnail tidak ada
          ??
          'https://kopmaunila.com/panel/img/logo-kopma-unila.png',
    );
  }
}
