class SimpananPoin {
  var simpananWajib;
  var simpananPokok;
  var tagihan;
  var poin;
  var denda;

  SimpananPoin({
    this.simpananWajib,
    this.simpananPokok,
    this.tagihan,
    this.poin,
    this.denda,
  });

  factory SimpananPoin.fromJson(Map<String, dynamic> json) {
    return SimpananPoin(
      simpananWajib: json['simpanan_wajib'],
      simpananPokok: json['simpanan_pokok'],
      tagihan: json['tagihan'],
      poin: json['poin'],
      denda: json['denda'],
    );
  }
}
