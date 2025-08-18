import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/LapkeuAPI.dart';
import '../component/LapkeuListItem.dart';
import '../data_model/LapkeuModel.dart';

class LaporanKeuanganScreen extends StatefulWidget {
  const LaporanKeuanganScreen({super.key});

  @override
  _LaporanKeuanganScreenState createState() => _LaporanKeuanganScreenState();
}

class _LaporanKeuanganScreenState extends State<LaporanKeuanganScreen> {
  Future<List<LaporanKeuanganModel>> dataLaporan = Future.value([]);
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = await LaporanKeuanganApi.getLaporanKeuangan();
    setState(() {
      dataLaporan = Future.value(data);
    });
  }

  void _refreshData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Keuangan',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ), // Menggunakan font Poppins dengan warna hitam
        ),
      ),
      body: FutureBuilder(
        future: dataLaporan,
        builder: (context, AsyncSnapshot<List<LaporanKeuanganModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _refreshData,
                  enablePullUp: true,
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        LaporanKeuanganItem(dataLaporan: snapshot.data![index]),
                    separatorBuilder: (context, index) =>
                        Container(height: 1, color: Colors.black26),
                    itemCount: snapshot.data!.length,
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Tidak ada data laporan'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
