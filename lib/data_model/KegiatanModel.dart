import 'dart:convert';

class KegiatanModel {
  String nama_kegiatan;
  String id_kegiatan;
  String tanggal_kegiatan;
  String tempat_kegiatan;

  KegiatanModel({
    required this.nama_kegiatan,
    required this.id_kegiatan,
    required this.tanggal_kegiatan,
    required this.tempat_kegiatan,
  });

  factory KegiatanModel.fromJson(json) {
    return KegiatanModel(
      nama_kegiatan: json['nama_kegiatan'],
      id_kegiatan: json['id_kegiatan'],
      tanggal_kegiatan: json['tanggal_kegiatan'],
      tempat_kegiatan: json['tempat_kegiatan'],
    );
  }
}
