import 'package:flutter/material.dart';
import '/database/database_helper.dart';
import 'edit_borrow_page.dart';

class HistoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const HistoryDetailPage({super.key, required this.data});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  late Map<String, dynamic> borrowData;

  @override
  void initState() {
    super.initState();
    borrowData = widget.data;
  }

  Future<void> refreshData() async {
    final list = await DatabaseHelper.instance
        .getBorrowByUser(borrowData['user_name']);

    setState(() {
      borrowData = list.firstWhere(
        (item) => item['id'] == borrowData['id'],
        orElse: () => borrowData,
      );
    });
  }

  Future<void> cancelBorrow() async {
    await DatabaseHelper.instance
        .updateBorrowStatus(borrowData['id'], "Dibatalkan");

    await refreshData();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Peminjaman dibatalkan")));
  }

  Future<void> editBorrow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBorrowPage(data: borrowData),
      ),
    );

    if (result == true) {
      await refreshData();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Peminjaman diperbarui")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Peminjaman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(borrowData['cover'],
                width: 120, height: 160, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(borrowData['book_title'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Nama: ${borrowData['user_name']}"),
            Text("Mulai: ${borrowData['borrow_date']}"),
            Text("Durasi: ${borrowData['days']} hari"),
            Text("Total: Rp ${borrowData['total_cost']}"),
            Text("Status: ${borrowData['status']}"),

            const Spacer(),

            if (borrowData['status'] == "Aktif")
              ElevatedButton(
                onPressed: editBorrow,
                child: const Text("Edit Peminjaman"),
              ),

            const SizedBox(height: 8),

            if (borrowData['status'] == "Aktif")
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: cancelBorrow,
                child: const Text("Batalkan Peminjaman"),
              ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Kembali ke Riwayat"),
            ),
          ],
        ),
      ),
    );
  }
}
