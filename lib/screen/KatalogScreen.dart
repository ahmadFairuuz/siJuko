import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/KatalogAPI.dart';
import '../component/KatalogUsahaItem.dart';
import '../data_model/KatalogModel.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  _KatalogScreenState createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final RefreshController _controller = RefreshController();
  Future<List<KatalogModel>> katalog = Future.value([]);
  var _waiting = true;

  @override
  void initState() {
    super.initState();
    getKatalog();
  }

  void getKatalog() async {
    setState(() {
      _waiting = true;
    });
    var data = await KatalogApi.getKatalog();
    setState(() {
      katalog = Future.value(data);
      _waiting = false;
    });
  }

  void _refresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getKatalog();
    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Katalog Usaha',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ), // Menggunakan font Poppins
        ),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white), // Warna hijau [900]
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, // Latar belakang putih
          borderRadius: BorderRadius.circular(10), // Radius sudut
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Bayangan halus
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FutureBuilder(
          future: katalog,
          builder: (context, AsyncSnapshot<List<KatalogModel>> snapshot) {
            if (!_waiting) {
              if (snapshot.data!.isNotEmpty) {
                return SmartRefresher(
                  controller: _controller,
                  onRefresh: _refresh,
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      return KatalogUsahaCardItem(
                        katalogModel: snapshot.data![index],
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'Tidak ada produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ), // Menggunakan Poppins
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
