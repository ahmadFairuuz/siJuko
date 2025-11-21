class RiwayatBayar {
  String waktuPembayaran;
  var nominal;
  var denda;
  String status;
  String namaLengkap;

  RiwayatBayar({
    required this.waktuPembayaran,
    required this.nominal,
    required this.denda,
    required this.status,
    required this.namaLengkap,
  });

  factory RiwayatBayar.fromJson(Map<String, dynamic> json) {
    return RiwayatBayar(
      waktuPembayaran: json['timestamp'],
      nominal: json['nominal'],
      denda: json['denda'],
      status: json['status'],
      namaLengkap: json['nama_lengkap'],
    );
  }
}
