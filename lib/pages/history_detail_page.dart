import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'edit_borrow_page.dart';

class HistoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const HistoryDetailPage({super.key, required this.data});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  Future<void> cancelBorrow() async {
    await DatabaseHelper.instance
        .updateBorrowStatus(data['id'], "Dibatalkan");

    setState(() {
      data['status'] = "Dibatalkan";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Peminjaman dibatalkan")),
    );

    Navigator.pop(context, true); // Kembali & refresh riwayat
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = data['status'] == "Aktif";

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Peminjaman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(data['cover'], width: 120, height: 160),
            ),
            const SizedBox(height: 16),
            Text(
              data['book_title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Nama: ${data['user_name']}"),
            Text("Tanggal Pinjam: ${data['borrow_date'].substring(0, 10)}"),
            Text("Lama Pinjam: ${data['days']} hari"),
            Text("Total: Rp ${data['total_cost']}"),
            Text(
              "Status: ${data['status']}",
              style: TextStyle(
                color: data['status'] == "Dibatalkan" ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            // Tombol Edit hanya jika status masih aktif
            if (isActive)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBorrowPage(data: data),
                    ),
                  );
                },
                child: const Text("Edit Peminjaman"),
              ),

            const SizedBox(height: 10),

            // Tombol Cancel hanya jika status masih aktif
            if (isActive)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: cancelBorrow,
                child: const Text("Batalkan Peminjaman"),
              ),

            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali"),
            )
          ],
        ),
      ),
    );
  }
}
