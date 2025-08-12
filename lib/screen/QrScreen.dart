import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../api/PresensiAPI.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isLoading = false;
  bool _torchOn = false;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final inputImage = InputImage.fromFilePath(pickedFile.path);
        final barcodeScanner = BarcodeScanner();
        final barcodes = await barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          final qrValue = barcodes.first.rawValue;
          if (qrValue != null && qrValue.isNotEmpty) {
            _processQrValue(qrValue);
            return;
          }
        }
        _showDialog("Error", "QR tidak valid dari gambar");
      } catch (e) {
        _showDialog("Error", "Gagal membaca gambar: $e");
      }
    }
  }

  void _processQrValue(String rawValue) async {
    setState(() => _isLoading = true);
    cameraController.stop();

    var response = await PresensiApi.presensi(rawValue);

    setState(() => _isLoading = false);

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

  void _handleBarcode(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
      _processQrValue(barcodes[0].rawValue!);
    }
  }

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

  void _toggleTorch() {
    cameraController.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            MobileScanner(
              controller: cameraController,
              onDetect: _handleBarcode,
            ),
          Positioned(
            bottom: 20,
            left: 40, // tombol torch di kiri
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                _torchOn ? Icons.flash_on : Icons.flash_off,
                color: _torchOn ? Colors.green[900] : Colors.grey,
              ),
              iconSize: 32.0,
              onPressed: _toggleTorch,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 300, // tombol torch di kiri
            child: IconButton(
              color: Colors.grey,
              icon: Icon(Icons.photo_library),
              iconSize: 35,
              onPressed: _pickImageFromGallery,
            ),
          ),
        ],
      ),
    );
  }
}
