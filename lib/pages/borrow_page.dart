import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';
import '../database/database_helper.dart';
import 'history_page.dart';

class BorrowPage extends StatefulWidget {
  final Book book;

  const BorrowPage({super.key, required this.book});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  String userName = "";
  TextEditingController daysCtrl = TextEditingController();
  DateTime? borrowDate = DateTime.now();
  int totalCost = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("name") ?? "Unknown";
    });
  }

  void calculateCost() {
    setState(() {
      int days = int.tryParse(daysCtrl.text) ?? 0;
      totalCost = (days > 0) ? days * widget.book.price : 0;
    });
  }

  Future<void> saveBorrow() async {
    print("DEBUG: saveBorrow() terpanggil!");

    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal: Nama peminjam tidak ditemukan! Login ulang."),
        ),
      );
      return;
    }

    if (daysCtrl.text.isEmpty ||
        int.tryParse(daysCtrl.text) == null ||
        int.parse(daysCtrl.text) <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lama pinjam harus angka > 0")));
      return;
    }

    try {
      await DatabaseHelper.instance.insertBorrow({
        'user_name': userName,
        'book_title': widget.book.title,
        'borrow_date': borrowDate.toString().substring(0, 10),
        'days': int.parse(daysCtrl.text),
        'total_cost': totalCost,
      });

      print("DEBUG: Data berhasil masuk DB");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Peminjaman Berhasil!")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HistoryPage()),
      );
    } catch (e) {
      print("ERROR saat insert: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan ketika menyimpan data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pinjam Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(widget.book.cover, width: 120, height: 160),
            ),
            SizedBox(height: 12),
            Text(
              widget.book.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(widget.book.genre),
            SizedBox(height: 12),
            Text("Nama Peminjam: $userName"),
            SizedBox(height: 12),
            Text("Tanggal Pinjam: ${borrowDate.toString().substring(0, 10)}"),
            SizedBox(height: 12),

            TextFormField(
              controller: daysCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Lama Pinjam (Hari)",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateCost(),
            ),

            SizedBox(height: 12),
            Text(
              "Total Biaya: Rp $totalCost",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            Spacer(),

            ElevatedButton(
              onPressed: () => saveBorrow(),
              child: Text("Konfirmasi Pinjam"),
            ),
          ],
        ),
      ),
    );
  }
}
