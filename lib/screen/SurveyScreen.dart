import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sijuko_newapp/api/SurveyApi.dart';
import 'package:sijuko_newapp/component/SurveyListItem.dart';
import 'package:sijuko_newapp/data_model/SurveyModel.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<SurveyModel> dataSurvey = [];
  RefreshController refreshController = RefreshController();
  var _waiting = true;

  void getData() async {
    setState(() {
      _waiting = true;
    });
    var data = await SurveyApi.getSurvey();
    setState(() {
      dataSurvey = data;
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
          'Laporan Keuangan',
          style: GoogleFonts.poppins(color: Colors.black), // Menggunakan font Poppins dengan warna hitam
        ),
      ),
      body: FutureBuilder(
        future: Future.value(dataSurvey),
        builder: (context, AsyncSnapshot<List<SurveyModel>> snapshot) {
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
                      return SurveyListItem(
                        dataSurvey: snapshot.data![index],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: dataSurvey.length,
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
