import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../component/BottomNavigation.dart';
import '../data_model/HomeData.dart';
import '../data_model/NotificationModel.dart';

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
  late Future<Box<NotificationModel>> _futureBox;

  @override
  void initState() {
    super.initState();
    // selalu reopen dari disk biar sync dengan background isolate
    _futureBox = Hive.openBox<NotificationModel>('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          FutureBuilder<Box<NotificationModel>>(
            future: _futureBox,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final box = snapshot.data!;
              return IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.green[900],
                  size: 32,
                ),
                tooltip: 'Hapus Semua',
                onPressed: () async {
                  await box.clear();
                },
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FutureBuilder<Box<NotificationModel>>(
        future: _futureBox,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final box = snapshot.data!;

          return Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<NotificationModel> box, _) {
                print("📊 Jumlah item di box (UI): ${box.length}");
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada notifikasi",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final notifs = box.values.toList().reversed.toList();

                return ListView.builder(
                  itemCount: notifs.length,
                  itemBuilder: (context, index) {
                    final notif = notifs[index];
                    return Card(
                      color: Colors.green[900],
                      child: ListTile(
                        title: Text(
                          notif.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          notif.body,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          notif.timestamp.toString().substring(0, 16),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
        homeData: widget.homeData,
      ),
    );
  }
}
