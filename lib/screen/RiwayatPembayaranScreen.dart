import 'package:flutter/material.dart';
import 'package:jukover7/api/RiwayatAPI.dart';
import 'package:jukover7/component/RiwayatList.dart';
import 'package:jukover7/data_model/RiwayatBayar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//RIWAYAT PEMBAYARAN
class RiwayatPembayaranScreen extends StatefulWidget {
  const RiwayatPembayaranScreen({super.key});

  @override
  State<RiwayatPembayaranScreen> createState() =>
      _RiwayatPembayaranScreenState();
}

class _RiwayatPembayaranScreenState extends State<RiwayatPembayaranScreen> {
  Future<List<RiwayatBayar>> dataRiwayat = Future.value([]);
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      dataRiwayat = RiwayatApi.getRiwayat();
    });
  }

  void refreshData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pembayaran Simpanan',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ), // Menggunakan font Poppins dengan warna hitam
        ),
      ),
      body: FutureBuilder(
        future: dataRiwayat,
        builder: (context, AsyncSnapshot<List<RiwayatBayar>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: refreshData,
                  enablePullUp: true,
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        Riwayatlist(dataRiwayat: snapshot.data![index]),
                    separatorBuilder: (context, index) =>
                        Container(height: 1, color: Colors.black26),
                    itemCount: snapshot.data!.length,
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Belum Ada Pembayaran'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
