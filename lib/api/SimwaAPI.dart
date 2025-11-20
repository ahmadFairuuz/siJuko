import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'configAPI.dart';

class SimwaApi {
  static Future<Map<String, dynamic>> bayarSimwa(
    String nominal,
    String denda,
    String bukti,
  ) async {
    final URL = '${Config.API_URL}bayar_simwa';

    var url = Uri.parse(URL);
    var request = http.MultipartRequest('POST', url);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nomorAnggota = prefs.getString('nomor_anggota')!;

    request.fields['nomor_anggota'] = nomorAnggota;
    request.fields['nominal'] = nominal;
    request.fields['denda'] = denda;

    request.files.add(
      await http.MultipartFile.fromPath('bukti_pembayaran', bukti),
    );
    var response = await request.send();

    return response.statusCode == 200
        ? {'status': true}
        : {'status': false, 'message': 'Gagal mengirim data'};
  }
}
