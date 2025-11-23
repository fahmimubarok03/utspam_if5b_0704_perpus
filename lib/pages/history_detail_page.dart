import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> borrowData;

  const HistoryDetailPage({super.key, required this.borrowData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Peminjaman")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(borrowData['cover'], width: 120, height: 160),
            SizedBox(height: 16),
            Text(borrowData['book_title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Nama: ${borrowData['user_name']}"),
            Text("Tanggal Pinjam: ${borrowData['borrow_date'].substring(0, 10)}"),
            Text("Lama Pinjam: ${borrowData['days']} hari"),
            Text("Total Biaya: Rp ${borrowData['total_cost']}"),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali"),
            )
          ],
        ),
      ),
    );
  }
}
