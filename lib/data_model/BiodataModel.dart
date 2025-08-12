class BiodataModel {
  String nomorAnggota;
  String npm;
  String nama;
  String email;
  String nomor_hp;
  String jenisKelamin;
  String jurusan;
  String fakultas;

  BiodataModel({
    required this.nomorAnggota,
    required this.npm,
    required this.nama,
    required this.email,
    required this.nomor_hp,
    required this.jenisKelamin,
    required this.jurusan,
    required this.fakultas,
  });

  factory BiodataModel.fromJson(json) {
    return BiodataModel(
      nomorAnggota: json['nomor_anggota'],
      npm: json['npm'],
      nama: json['nama_lengkap'],
      email: json['email'],
      nomor_hp: json['nomor_hp'],
      jenisKelamin: json['jenis_kelamin'],
      jurusan: json['jurusan'],
      fakultas: json['fakultas'],
    );
  }

  toJson(data) {
    Map<String, String> map = {
      'nomor_anggota': data.nomorAnggota,
      'npm': data.npm,
      'nama_lengkap': data.nama,
      'email': data.email,
      'nomor_hp': data.nomor_hp,
      'jenis_kelamin': data.jenisKelamin,
      'jurusan': data.jurusan,
      'fakultas': data.fakultas,
    };
    return map;
  }
}
