import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Peminjaman")),
      body: const Center(
        child: Text(
          "Belum ada riwayat peminjaman",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
