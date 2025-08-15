import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewScreen extends StatelessWidget {
  final String url;

  const PDFViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PDF View',
          style: TextStyle(fontFamily: 'Poppins'), // Menggunakan font Poppins
        ),
      ),
    );
  }
}
