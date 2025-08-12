class DigilibModel {
  String id;
  String judul;
  String deskripsi;
  String file;

  DigilibModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.file,
  });

  factory DigilibModel.fromJson(Map<String, dynamic> json) {
    return DigilibModel(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      file: json['file'],
    );
  }
}
