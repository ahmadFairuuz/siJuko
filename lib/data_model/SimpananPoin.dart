class SimpananPoin {
  var simpananWajib;
  var simpananPokok;
  var tagihan;
  var poin;

  SimpananPoin({
    this.simpananWajib,
    this.simpananPokok,
    this.tagihan,
    this.poin,
  });

  factory SimpananPoin.fromJson(Map<String, dynamic> json) {
    return SimpananPoin(
      simpananWajib: json['simpanan_wajib'],
      simpananPokok: json['simpanan_pokok'],
      tagihan: json['tagihan'],
      poin: json['poin'],
    );
  }
}
