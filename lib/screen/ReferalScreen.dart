import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferalScreen extends StatefulWidget {
  const ReferalScreen({Key? key}) : super(key: key);

  @override
  _ReferalScreenState createState() => _ReferalScreenState();
}

class _ReferalScreenState extends State<ReferalScreen> {
  String? referal = '';
  var _waiting = true;

  @override
  void initState() {
    super.initState();
    getReferal();
  }

  void getReferal() async {
    setState(() {
      _waiting = true;
    });
    SharedPreferences sPref = await SharedPreferences.getInstance();
    var nomor_anggota = sPref.getString("nomor_anggota");
    var nama = sPref.getString("nama");
    var kode = nama!.substring(0, 3) + nomor_anggota!.substring(0, 4);
    setState(() {
      referal = kode;
      _waiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kode Referal',
          style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
        ),),
        backgroundColor: Colors.green[900],

        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: _waiting
            ? Center(child: CircularProgressIndicator())
            : Center(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                alignment: Alignment.center,
              ),
              Positioned(
                top: 50,
                left: 24,
                right: 24,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(1, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Kode Referal Anda',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        referal!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 1,
                        color: Colors.black38,
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Ajak teman anda untuk bergabung ke Kopma, dan gunakan kode referal anda ketika mendaftar',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Icon(
                  Icons.local_attraction_sharp,
                  size: 100,
                  color: Colors.green,
                  shadows: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
