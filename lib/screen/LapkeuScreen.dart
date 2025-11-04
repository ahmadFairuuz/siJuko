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
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  List<LaporanKeuanganModel> _laporanList = [];
  int _currentPage = 1;
  final int _limit = 10; // jumlah data per page
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchData(reset: true);
  }

  Future<void> _fetchData({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _laporanList.clear();
      _hasMore = true;
    }

    try {
      final newData = await LaporanKeuanganApi.getLaporanKeuangan(
        page: _currentPage,
        limit: _limit,
      );

      setState(() {
        _laporanList.addAll(newData);
        if (newData.length < _limit) {
          _hasMore = false; // sudah habis
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _onRefresh() async {
    await _fetchData(reset: true);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (_hasMore) {
      _currentPage++;
      await _fetchData();
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
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
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        enablePullUp: true,
        child: _laporanList.isEmpty
            ? const Center(child: Text("Tidak ada data laporan"))
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return LaporanKeuanganItem(dataLaporan: _laporanList[index]);
                },
                separatorBuilder: (context, index) =>
                    Container(height: 1, color: Colors.black26),
                itemCount: _laporanList.length,
              ),
      ),
    );
  }
}
