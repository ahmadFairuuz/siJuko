class SurveyModel {
  String id;
  String nama_survey;
  String deskripsi;
  String tgl_mulai;
  String tgl_selesai;
  String link;

  SurveyModel({
    required this.id,
    required this.nama_survey,
    required this.deskripsi,
    required this.tgl_mulai,
    required this.tgl_selesai,
    required this.link,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'],
      nama_survey: json['nama_survey'],
      deskripsi: json['deskripsi'],
      tgl_mulai: json['tgl_mulai'],
      tgl_selesai: json['tgl_selesai'],
      link: json['link'],
    );
  }
}
