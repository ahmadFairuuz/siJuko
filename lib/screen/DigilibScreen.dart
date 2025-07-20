import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sijuko_newapp/api/DigilibAPI.dart';
import 'package:sijuko_newapp/component/DigilibList.dart';
import 'package:sijuko_newapp/data_model/DigilibModel.dart';

class DigilibScreen extends StatefulWidget {
  const DigilibScreen({Key? key}) : super(key: key);

  @override
  _DigilibScreenState createState() => _DigilibScreenState();
}

class _DigilibScreenState extends State<DigilibScreen> {
  List<DigilibModel> digitalLibrary = [];
  RefreshController refreshController = RefreshController();
  var _waiting = true;

  void getData() async {
    setState(() {
      _waiting = true;
    });
    var data = await DigilibApi.getDigilib();
    setState(() {
      digitalLibrary = data;
      _waiting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    getData();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Library',
          style: GoogleFonts.poppins(), // Menggunakan font Poppins
        ),
      ),
      body: FutureBuilder(
        future: Future.value(digitalLibrary),
        builder: (context, AsyncSnapshot<List<DigilibModel>> snapshot) {
          if (!_waiting) {
            if (snapshot.data!.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: SmartRefresher(
                  onRefresh: _refreshData,
                  controller: refreshController,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return DigilibListItem(
                          dataDigilib: snapshot.data![index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: digitalLibrary.length,
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Tidak ada data'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
