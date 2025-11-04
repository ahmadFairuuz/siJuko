import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/DigilibAPI.dart';
import '../component/DigilibList.dart';
import '../data_model/DigilibModel.dart';

class DigilibScreen extends StatefulWidget {
  const DigilibScreen({super.key});

  @override
  _DigilibScreenState createState() => _DigilibScreenState();
}

class _DigilibScreenState extends State<DigilibScreen> {
  List<DigilibModel> digitalLibrary = [];
  RefreshController refreshController = RefreshController();

  bool _waiting = true;
  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _getData(reset: true);
  }

  Future<void> _getData({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      digitalLibrary.clear();
    }

    setState(() => _waiting = true);

    try {
      var data = await DigilibApi.getDigilib(page: _page, limit: _limit);

      setState(() {
        if (reset) {
          digitalLibrary = data;
        } else {
          digitalLibrary.addAll(data);
        }

        // Jika jumlah data < limit berarti sudah habis
        if (data.length < _limit) {
          _hasMore = false;
        } else {
          _page++;
        }
      });
    } catch (e) {
      debugPrint("❌ Error fetch data: $e");
    }

    setState(() => _waiting = false);
  }

  void _onRefresh() async {
    await _getData(reset: true);
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (_hasMore) {
      await _getData();
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Library',
          style: TextStyle(fontFamily: 'Poppins'), // Menggunakan font Poppins
        ),
      ),
      body: _waiting && digitalLibrary.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : digitalLibrary.isEmpty
          ? const Center(child: Text('Tidak ada data'))
          : Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: SmartRefresher(
                controller: refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                enablePullUp: true, // ⬅️ penting untuk infinite scroll
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return DigilibListItem(dataDigilib: digitalLibrary[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: digitalLibrary.length,
                ),
              ),
            ),
    );
  }
}
