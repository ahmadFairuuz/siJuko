class KatalogModel {
  String id;
  String nama_produk;
  String harga_produk;
  String file;

  KatalogModel({
    required this.id,
    required this.nama_produk,
    required this.harga_produk,
    required this.file,
  });

  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      id: json['id_produk'],
      nama_produk: json['nama_produk'],
      harga_produk: json['harga_produk'],
      file: json['gambar_produk'],
    );
  }
}
