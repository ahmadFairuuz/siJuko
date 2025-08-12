import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../api/PresensiAPI.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isLoading = false;
  bool _torchOn =
      false; // Tambahkan state untuk mengelola status torch secara manual

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                cameraController.start();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleBarcode(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty || barcodes[0].rawValue == null) {
      _showDialog("Error", "QR Tidak valid");
      return;
    }

    String rawValue = barcodes[0].rawValue!;

    setState(() {
      _isLoading = true;
    });

    cameraController.stop();

    var response = await PresensiApi.presensi(rawValue);

    setState(() {
      _isLoading = false;
    });

    if (response.isNotEmpty) {
      if (response['status'] == 200) {
        _showDialog("Sukses", response['messages']);
      } else {
        String errorMessage =
            response['messages']['error'] ?? response['messages'].toString();
        _showDialog("Gagal", errorMessage);
      }
    } else {
      _showDialog("Error", "QR Tidak valid");
    }
  }

  void _toggleTorch() {
    cameraController.toggleTorch();
    setState(() {
      _torchOn = !_torchOn; // Mengubah status torch setiap kali tombol ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isLoading) ...[
          Center(child: CircularProgressIndicator()),
        ] else ...[
          MobileScanner(controller: cameraController, onDetect: _handleBarcode),
        ],
        Positioned(
          bottom: 20,
          right: 40,
          child: IconButton(
            color: Colors.white,
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? Colors.green[900] : Colors.grey,
            ),
            iconSize: 32.0,
            onPressed:
                _toggleTorch, // Memanggil fungsi toggleTorch saat tombol ditekan
          ),
        ),
      ],
    );
  }
}
