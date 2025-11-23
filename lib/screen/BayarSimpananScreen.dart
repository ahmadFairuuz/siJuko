import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jukover7/screen/RiwayatPembayaranScreen.dart';

import '../api/SimwaAPI.dart';

class BayarScreen extends StatefulWidget {
  const BayarScreen({super.key});

  @override
  State<BayarScreen> createState() => _BayarScreenState();
}

class _BayarScreenState extends State<BayarScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  ImagePicker picker = ImagePicker();
  var _waiting = false;

  void _setWait() {
    setState(() {
      _waiting = !_waiting;
    });
  }

  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _dendaController = TextEditingController();

  Future<void> _pickImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan tap di luar
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
                SizedBox(height: 16),
                Text(
                  "Pembayaran Berhasil!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Silakan menunggu konfirmasi dari tim bidang keuangan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // tutup dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RiwayatPembayaranScreen(),
                      ),
                    );
                  },
                  child: Text("Lanjut", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //PEMBAYARAN GAGAL
  void showFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel_rounded, color: Colors.red, size: 80),
                SizedBox(height: 16),
                Text(
                  "Pembayaran Gagal!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Silakan periksa kembali data yang Anda masukkan.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bayar Simpanan", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: !_waiting
            ? SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://kopmaunila.com/panel/img/bank_bayar_simwa.jpg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Isikan Nominal yang dibayarkan',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text("Rp", style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _nominalController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 22),
                                decoration: InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Isikan Denda Tagihan',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text("Rp", style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _dendaController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 22),
                                decoration: InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Upload Bukti Pembayaran (Max 1 File)',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.image, color: Colors.black),
                                  Spacer(), // Mengisi ruang di antara kedua ikon
                                  Icon(Icons.add_circle, color: Colors.green),
                                ],
                              ),
                              const SizedBox(height: 15),
                              if (_image != null)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (_nominalController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Nominal tidak boleh kosong"),
                                ),
                              );
                              return;
                            }
                            if (_image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Bukti pembayaran tidak boleh kosong",
                                  ),
                                ),
                              );
                              return;
                            }

                            var angka = num.tryParse(_nominalController.text);
                            var denda = num.tryParse(_dendaController.text);

                            if (angka == null || denda == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Nominal / denda harus berupa angka",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (angka < 10000) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Nominal minimal Rp 10.000"),
                                ),
                              );
                              return;
                            }

                            _setWait();
                            Map<String, dynamic> response =
                                await SimwaApi.bayarSimwa(
                                  _nominalController.text,
                                  _dendaController.text,
                                  _image!.path,
                                );
                            _setWait();

                            if (response['status']) {
                              showSuccessDialog(context);
                            } else {
                              showFailedDialog(context);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 16,
                              right: 16,
                              left: 16,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
