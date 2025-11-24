import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String userName = "";
  List<Map<String, dynamic>> historyList = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("name") ?? "Unknown";
    loadHistory();
  }

  Future<void> loadHistory() async {
    var data = await DatabaseHelper.instance.getBorrowByUser(userName);
    setState(() {
      historyList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Peminjaman"),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          var item = historyList[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(item["book_title"] ?? "Tanpa Judul"),
              subtitle: Text(
                "Peminjam: ${item["user_name"] ?? 'Tidak diketahui'}\n"
                "Tanggal: ${item["borrow_date"]?.toString().substring(0,10) ?? '-'}\n"
                "Lama: ${item["days"]?.toString() ?? '0'} hari\n"
                "Total: Rp ${item["total_cost"]?.toString() ?? '0'}",
              ),
            ),
          );
        },
      ),
    );
  }
}
