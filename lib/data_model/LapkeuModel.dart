class LaporanKeuanganModel {
  String id;
  String judul;
  String bulan;
  String tahun;
  String link;

  LaporanKeuanganModel({
    required this.id,
    required this.judul,
    required this.bulan,
    required this.tahun,
    required this.link,
  });

  factory LaporanKeuanganModel.fromJson(json) {
    return LaporanKeuanganModel(
      id: json['id'],
      judul: json['judul'],
      bulan: json['bulan'],
      tahun: json['tahun'],
      link: json['file'],
    );
  }
}
