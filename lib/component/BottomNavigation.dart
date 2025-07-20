import 'package:flutter/material.dart';

// import 'package:jukover7/screen/BiodataScreen.dart';
// import 'package:jukover7/screen/NotificationScreen.dart';
// import 'package:jukover7/screen/ProfileScreen.dart';
// import 'package:jukover7/screen/QrScreen.dart';
import '../data_model/HomeData.dart';
import '../screen/AllPostScreen.dart';
import '../screen/HomeScreen.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Future<HomeData> homeData;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.homeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Post'),
          BottomNavigationBarItem(
            icon: SizedBox(width: 40, height: 40, child: Icon(Icons.qr_code)),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllPostScreen(homeData: homeData),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => const QrScreen()),
              MaterialPageRoute(
                builder: (context) => AllPostScreen(homeData: homeData),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              /*MaterialPageRoute(
                builder: (context) => NotificationScreen(
                  homeData: homeData,
                  selectedIndex: selectedIndex,
                  onItemTapped: (int) {},
                ),
              ),*/
              MaterialPageRoute(
                builder: (context) => AllPostScreen(homeData: homeData),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              /*MaterialPageRoute(
                builder: (context) => ProfileTab(homeData: homeData),
              ),*/
              MaterialPageRoute(
                builder: (context) => AllPostScreen(homeData: homeData),
              ),
            );
          } else {
            onItemTapped(index);
          }
        },
      ),
    );
  }
}
