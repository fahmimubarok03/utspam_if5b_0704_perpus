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
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name") ?? "";
    final data = await DatabaseHelper.instance.getBorrowByUser(userName);
    setState(() => borrowList = data.reversed.toList());
  }

  Future<void> openDetail(Map<String, dynamic> item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoryDetailPage(data: item),
      ),
    );

    if (result == true) {
      await loadData();
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Aktif":
        return Colors.green;
      case "Dibatalkan":
        return Colors.red;
      case "Selesai":
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Peminjaman")),
      body: borrowList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat peminjaman.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: borrowList.length,
              itemBuilder: (context, i) {
                final item = borrowList[i];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item['cover'],
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item['book_title']),
                    subtitle: Text(
                      "Rp ${item['total_cost']} - ${item['status']}",
                      style: TextStyle(
                        color: statusColor(item['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => openDetail(item),
                  ),
                );
              },
            ),
    );
  }
}
