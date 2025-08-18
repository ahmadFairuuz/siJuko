import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/GetPostPoin.dart';
import '../component/BottomNavigation.dart';
import '../component/HomeListButton.dart';
import '../component/PostItem.dart';
import '../data_model/HomeData.dart';
import '../data_model/SimpananPoin.dart';
import '../screen/AllPostScreen.dart';
import '../screen/BayarSimpananScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllPostScreen(homeData: homeData!),
          ),
        );
        break;
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    nama,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4),
                                  FutureBuilder<HomeData>(
                                    future: homeData,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          'Poin: ...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Poin: Error',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        );
                                      } else if (snapshot.hasData) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.monetization_on,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                '${snapshot.data!.simpananPoin.poin}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text(
                                          'Poin: 0',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Tombol Bayar Tagihan
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BayarScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[900],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Bayar Tagihan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  // Tombol Riwayat Tagihan
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => HomeScreen(),
                                  //       ),
                                  //     );
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.grey[800],
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20,
                                  //       vertical: 12,
                                  //     ),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //     ),
                                  //   ),
                                  //   child: const Text(
                                  //     'Riwayat Tagihan',
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontFamily: 'Poppins',
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
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
                                      color: Colors.green[900],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllPostScreen(
                                            homeData: homeData!,
                                          ),
                                        ),
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
                                } else if (snapshot.hasData &&
                                    snapshot.data!.posts.isNotEmpty) {
                                  return PostItem(
                                    post: snapshot.data!.posts[0],
                                  );
                                } else {
                                  return Center(child: Text("Tidak ada post"));
                                }
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
            Future.value(HomeData(posts: [], simpananPoin: SimpananPoin())),
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
