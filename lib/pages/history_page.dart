import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String userName = "";
  List<Map<String, dynamic>> borrowList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name") ?? "";

    final data = await DatabaseHelper.instance.getBorrowByUser(userName);

    setState(() {
      borrowList = data;
    });
  }

  void _openDetail(Map<String, dynamic> borrowData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryDetailPage(data: borrowData),
      ),
    );

    if (result == true) {
      loadData(); // REFRESH setelah batal/edit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Peminjaman")),
      body: borrowList.isEmpty
          ? const Center(child: Text("Belum ada riwayat peminjaman."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: borrowList.length,
              itemBuilder: (context, index) {
                var data = borrowList[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      data['cover'],
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(data['book_title']),
                    subtitle: Text("Status: ${data['status']}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _openDetail(data), // FIXED!
                  ),
                );
              },
            ),
    );
  }
}
