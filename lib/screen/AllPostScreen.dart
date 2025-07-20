import 'package:flutter/material.dart';

// import 'package:jukover7/screen/QrScreen.dart';
import '../component/BottomNavigation.dart';
import '../component/PostItem.dart';
import '../data_model/HomeData.dart';
import 'HomeScreen.dart';

class AllPostScreen extends StatefulWidget {
  final Future<HomeData> homeData;

  AllPostScreen({super.key, required this.homeData});

  @override
  _AllPostScreenState createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  int _selectedIndex = 1; // Mengatur index yang terpilih untuk navigasi

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Memperbarui index yang terpilih
    });
    // Navigasi sesuai dengan index yang dipilih
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      // Tetap di AllPostScreen
    } else if (index == 2) {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QrScreen()),
      // );
    } else {
      // Tambahkan navigasi untuk QR, Notification, dan Profile jika ada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.green[900], // Mengatur latar belakang menjadi hijau [900]
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Judul "Semua Postingan" di tengah atas
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20),
              child: Text(
                'Semua Postingan',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Menampilkan semua postingan
            Expanded(
              child: FutureBuilder<HomeData>(
                future: widget.homeData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.posts.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.posts.length,
                        itemBuilder: (context, index) {
                          return PostItem(post: snapshot.data!.posts[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Tidak ada post",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  }
                  return const Center(
                    child: Text(
                      "Tidak ada data.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        homeData: widget.homeData, // Mengoper homeData ke BottomNavigation
      ),
    );
  }
}
