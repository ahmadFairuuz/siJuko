import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_model/KatalogModel.dart';

class KatalogUsahaCardItem extends StatelessWidget {
  KatalogModel katalogModel;
  KatalogUsahaCardItem({super.key, required this.katalogModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            katalogModel.file,
            width: 100,
            height: 100,
            alignment: Alignment.center,
          ),
          Text(
            katalogModel.nama_produk.length > 20
                ? '${katalogModel.nama_produk.substring(0, 20)}...'
                : katalogModel.nama_produk,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.start,
          ),
          Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp',
              decimalDigits: 0,
            ).format(double.parse(katalogModel.harga_produk)).toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade800,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
