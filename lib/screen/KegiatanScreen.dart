import 'package:flutter/material.dart';
import 'package:jukover7/api/KegiatanAPI.dart';
import 'package:jukover7/component/KegiatanListItem.dart';
import 'package:jukover7/data_model/KegiatanModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KegiatanScreen extends StatefulWidget {
  const KegiatanScreen({Key? key}) : super(key: key);

  @override
  State<KegiatanScreen> createState() => _KegiatanScreenState();
}

class _KegiatanScreenState extends State<KegiatanScreen> {
  Future<List<KegiatanModel>> dataKegiatan = Future.value([]);
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<KegiatanModel> data = await KegiatanApi.getKegiatan();
    setState(() {
      dataKegiatan = Future.value(data);
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
          'Kegiatan Terdekat',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ), // Menggunakan font Poppins dengan warna hitam
        ),
      ),
      body: FutureBuilder(
        future: dataKegiatan,
        builder: (context, AsyncSnapshot<List<KegiatanModel>> snapshot) {
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
                        KegiatanItem(dataKegiatan: snapshot.data![index]),
                    separatorBuilder: (context, index) =>
                        Container(height: 1, color: Colors.black26),
                    itemCount: snapshot.data!.length,
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Belum ada Kegiatan Terdekat'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
