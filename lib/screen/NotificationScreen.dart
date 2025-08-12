import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/FirebaseApi.dart';
import '../component/BottomNavigation.dart';
import '../data_model/HomeData.dart';

class NotificationScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Future<HomeData> homeData;

  const NotificationScreen({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.homeData,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await FirebaseApi.getStoredNotifications();
    setState(() {
      notifications = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNotifications(); // reload setiap screen dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Biar putih bersih
        elevation: 0, // Hilangkan bayangan abu-abu
        automaticallyImplyLeading: false,
        titleSpacing: 25,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        foregroundColor: Colors.green[900],
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.green.shade900, // atau Colors.green[900]!
              size: 32,
            ),
            tooltip: 'Hapus Semua',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('notifications');
              setState(() {
                notifications.clear();
              });
            },
          ),
          const SizedBox(width: 20), // spacing ke kanan
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: notifications.isEmpty
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Card(
                    color: Colors.green[900], // warna background box
                    child: ListTile(
                      title: Text(
                        notif['title'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ), // teks putih
                      ),
                      subtitle: Text(
                        notif['body'] ?? '',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      trailing: Text(
                        notif['time']!.substring(0, 13),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
        homeData: widget.homeData,
      ),
    );
  }
}
