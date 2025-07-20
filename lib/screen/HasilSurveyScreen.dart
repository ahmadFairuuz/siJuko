import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sijuko_newapp/component/HasilSurveyListItem.dart';
import 'package:sijuko_newapp/data_model/HasilSurveyModel.dart';
import 'package:sijuko_newapp/api/HasilSurveyAPI.dart';

class HasilSurveyScreen extends StatefulWidget {
  const HasilSurveyScreen({Key? key}) : super(key: key);

  @override
  _HasilSurveyScreenState createState() => _HasilSurveyScreenState();
}

class _HasilSurveyScreenState extends State<HasilSurveyScreen> {
  List<HasilSurveyModel> hasilSurvey = [];
  RefreshController refreshController = RefreshController();
  var _waiting = true;

  void getData() async {
    setState(() {
      _waiting = true;
    });
    var data = await HasilSurveyApi.getHasilSurvey();
    setState(() {
      hasilSurvey = data;
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
          'Hasil Survey',
          style: GoogleFonts.poppins(color: Colors.black), // Menggunakan font Poppins dengan warna hitam
        ),
      ),
      body: FutureBuilder(
        future: Future.value(hasilSurvey),
        builder: (context, AsyncSnapshot<List<HasilSurveyModel>> snapshot) {
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
                      return HasilSurveyListItem(
                          dataLaporan: snapshot.data![index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: hasilSurvey.length,
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
