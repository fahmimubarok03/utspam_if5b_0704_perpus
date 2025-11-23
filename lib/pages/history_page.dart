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
  List<Map<String, dynamic>> borrowList = [];
  String userName = "";

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name") ?? "";

    final data = await DatabaseHelper.instance.getBorrowByUser(userName);

    setState(() => borrowList = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Peminjaman")),
      body: borrowList.isEmpty
          ? const Center(child: Text("Belum ada riwayat peminjaman"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: borrowList.length,
              itemBuilder: (context, index) {
                final item = borrowList[index];

                return Card(
                  child: ListTile(
                    leading: Image.asset(item['cover'], width: 55, height: 80),
                    title: Text(item['book_title']),
                    subtitle: Text("Biaya: Rp ${item['total_cost']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HistoryDetailPage(borrowData: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
