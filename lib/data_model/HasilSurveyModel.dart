class HasilSurveyModel {
  String id_laporan;
  String nama_survey;
  String deskripsi;
  String tgl_mulai;
  String tgl_selesai;
  String jml_responden;
  String file;

  HasilSurveyModel({
    required this.id_laporan,
    required this.nama_survey,
    required this.deskripsi,
    required this.tgl_mulai,
    required this.tgl_selesai,
    required this.jml_responden,
    required this.file,
  });

  factory HasilSurveyModel.fromJson(Map<String, dynamic> json) {
    return HasilSurveyModel(
      id_laporan: json['id_laporan'],
      nama_survey: json['nama_survey'],
      deskripsi: json['deskripsi'],
      tgl_mulai: json['tanggal_mulai'],
      tgl_selesai: json['tanggal_selesai'],
      jml_responden: json['jumlah_responden'],
      file: json['file'],
    );
  }
}
