import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/BiodatAPI.dart';
import '../data_model/BiodataModel.dart';
import '../screen/EditBioDataScreen.dart';

class BiodataScreen extends StatefulWidget {
  BiodataScreen({super.key});

  @override
  _BiodataScreenState createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  Future<BiodataModel>? biodata;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _refreshBiodata();
  }

  void _refreshBiodata() async {
    var data = await BiodataApi.getBiodata();
    setState(() {
      biodata = Future.value(data);
    });
  }

  void _refresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshBiodata();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900], // Set background color
      appBar: AppBar(
        title: Text(
          'Biodata',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: biodata,
        builder: ((context, AsyncSnapshot<BiodataModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return SmartRefresher(
                controller: refreshController,
                onRefresh: _refresh,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.transparent,
                        ),
                        // Menurunkan nilai top untuk menaikkan posisi kotak informasi
                        Positioned(
                          top: -30, // Ganti 0.5 menjadi 20 untuk menaikkan
                          left: 0.5,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.nama.toUpperCase() ?? '-',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                snapshot.data!.nomorAnggota ?? '-',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Mengurangi nilai top untuk menaikkan posisi kotak biodata
                        Positioned(
                          top: 130, // Ganti 160 menjadi 130 untuk menaikkan
                          right: 0,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInfoRow("NPM", snapshot.data!.npm),
                                buildInfoRow("Email", snapshot.data!.email),
                                buildInfoRow(
                                  "Nomor Handphone",
                                  snapshot.data!.nomor_hp,
                                ),
                                buildInfoRow(
                                  "Jenis Kelamin",
                                  snapshot.data!.jenisKelamin == "L"
                                      ? "Laki-laki"
                                      : "Perempuan",
                                ),
                                buildInfoRow("Jurusan", snapshot.data!.jurusan),
                                buildInfoRow(
                                  "Fakultas",
                                  snapshot.data!.fakultas,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ), // Reduce spacing to move the button up
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => EditBiodataScreen()),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Edit Biodata',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.green[900],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Gagal mendapatkan biodata',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red[900],
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]!),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget buildInfoRow(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black45,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value ?? '-',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
