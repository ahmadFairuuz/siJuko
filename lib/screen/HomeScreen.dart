import 'package:flutter/material.dart';
import 'package:jukover7/api/GetPostPoin.dart';
import 'package:jukover7/component/HomeListButton.dart';
import 'package:jukover7/component/PostItem.dart';
import 'package:jukover7/data_model/HomeData.dart';
import 'package:jukover7/screen/AllPostScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/BottomNavigation.dart';
import '../data_model/SimpananPoin.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<HomeData>? homeData;
  String nama = "";
  bool _wait = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future<void> getName() async {
    setState(() {
      _wait = true;
    });

    try {
      homeData = GetPostPoin.getHomeData();
      SharedPreferences sPref = await SharedPreferences.getInstance();
      setState(() {
        nama = sPref.getString('nama') ?? 'Pengguna';
        _wait = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _wait = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1: // Post
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllPostScreen(homeData: homeData!),
          ),
        );
        break;
      // Tambahkan case lain untuk QR, Notification, Profile jika ada
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _wait
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.green[900],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 35,
                              backgroundImage: AssetImage(
                                'assets/image/juko_merah.png',
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      nama,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        //TES API
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    FutureBuilder<HomeData>(
                                      // FutureBuilder untuk menampilkan poin
                                      future: homeData,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            'Poin: ...',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Poin: Error',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20.0,
                                              top: 10.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.monetization_on,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '${snapshot.data!.simpananPoin.poin}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            'Poin: 0',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FutureBuilder<HomeData>(
                              future: homeData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (snapshot.hasData) {
                                  String simpanan = snapshot
                                      .data!
                                      .simpananPoin
                                      .simpananWajib
                                      .toString();
                                  String tagihan = snapshot
                                      .data!
                                      .simpananPoin
                                      .tagihan
                                      .toString();

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildBalanceInfo(
                                        'Simpanan',
                                        'Rp.$simpanan',
                                      ),
                                      buildBalanceInfo(
                                        'Tagihan',
                                        'Rp.$tagihan',
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(child: Text('Tidak ada data.'));
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Bayar Tagihan',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[900],
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            HomeListButton(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Postingan Terbaru',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigasi ke AllPostView
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllPostScreen(
                                            homeData: homeData!,
                                          ),
                                        ),
                                        // Arahkan ke AllPostView
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Lihat Semua',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder<HomeData>(
                              // Menampilkan post terbaru
                              future: homeData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.posts.isNotEmpty) {
                                    return PostItem(
                                      post: snapshot.data!.posts[0],
                                    );
                                  } else {
                                    return Center(
                                      child: Text("Tidak ada post"),
                                    );
                                  }
                                }
                                return const Center(
                                  child: Text("Tidak ada data."),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        homeData:
            homeData ??
            Future.value(
              HomeData(posts: [], simpananPoin: SimpananPoin()),
            ), // Menyediakan nilai default jika null
      ),
    );
  }

  Widget buildBalanceInfo(String title, String balance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          balance,
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
      ],
    );
  }
}
