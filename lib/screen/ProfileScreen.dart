import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/BottomNavigation.dart';
import '../component/ProfileMenuListItem.dart';
import '../data_model/HomeData.dart';
import '../screen/BiodataScreen.dart';
import '../screen/LoginScreen.dart';
import '../screen/ReferalScreen.dart';
import '../screen/ResetPasswordScreen.dart';
import 'AllPostScreen.dart';
import 'HomeScreen.dart';
import 'QrScreen.dart';

class ProfileTab extends StatefulWidget {
  final Future<HomeData> homeData;

  const ProfileTab({super.key, required this.homeData});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? _name = "";
  String? _nomorAnggota = "";
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    getName();
  }

  Future<void> getName() async {
    SharedPreferences sPref = await SharedPreferences.getInstance();
    var nama = sPref.getString("nama");
    var nomorAnggota = sPref.getString("nomor_anggota");
    setState(() {
      _name = nama;
      _nomorAnggota = nomorAnggota;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllPostScreen(homeData: widget.homeData),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QrScreen()),
      );
    }
  }

  /// fungsi untuk buka Play Store
  Future<void> _launchPlayStore() async {
    const packageName = "com.kopmaul.sijuko"; // ganti dengan applicationId kamu
    final url = Uri.parse(
      "https://play.google.com/store/apps/details?id=$packageName",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Tidak bisa membuka Play Store";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[900]!.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        "assets/image/juko_merah.png",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // ← Tambahkan ini untuk mencegah overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _name ?? 'Loading...',
                          style: TextStyle(
                            fontSize:
                                20, // Sedikit kecilkan jika masih overflow
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _nomorAnggota ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                childAspectRatio: 2.5,
                children: [
                  ProfileMenuListItem(
                    label: "Biodata Kamu",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BiodataScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuListItem(
                    label: "Kode Referalmu",
                    icon: Icons.card_giftcard,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReferalScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuListItem(
                    label: "Reset Password",
                    icon: Icons.key,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuListItem(
                    label: "Beri Rating",
                    icon: Icons.star,
                    onTap: _launchPlayStore,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sPref =
                        await SharedPreferences.getInstance();
                    sPref.clear();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 24,
                    ),
                    backgroundColor: Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        homeData: widget.homeData,
      ),
    );
  }
}
