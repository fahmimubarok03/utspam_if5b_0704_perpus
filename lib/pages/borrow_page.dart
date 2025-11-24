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
  final daysCtrl = TextEditingController();
  DateTime borrowDate = DateTime.now();
  int totalCost = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "Unknown";
    });
  }

  void calculateCost() {
    int days = int.tryParse(daysCtrl.text) ?? 0;
    setState(() => totalCost = (days > 0) ? days * widget.book.price : 0);
  }

  Future<void> saveBorrow() async {
    if (userName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login ulang, nama tidak ditemukan")));
      return;
    }
    if (daysCtrl.text.isEmpty || int.tryParse(daysCtrl.text) == null || int.parse(daysCtrl.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lama pinjam harus angka > 0")));
      return;
    }

    try {
      await DatabaseHelper.instance.insertBorrow({
        'user_name': userName,
        'book_title': widget.book.title,
        'cover': widget.book.cover,
        'borrow_date': borrowDate.toString().substring(0, 10),
        'days': int.parse(daysCtrl.text),
        'total_cost': totalCost,
        'status': 'Aktif'
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Peminjaman Berhasil!")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan ketika menyimpan data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pinjam Buku")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Image.asset(widget.book.cover, width: 120, height: 160, fit: BoxFit.cover)),
              const SizedBox(height: 12),
              Text(widget.book.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(widget.book.genre),
              const SizedBox(height: 12),
              Text("Nama Peminjam: $userName"),
              const SizedBox(height: 8),
              Text("Tanggal Pinjam: ${borrowDate.toString().substring(0, 10)}"),
              const SizedBox(height: 12),
              TextFormField(
                controller: daysCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Lama Pinjam (Hari)", border: OutlineInputBorder()),
                onChanged: (_) => calculateCost(),
              ),
              const SizedBox(height: 12),
              Text("Total Biaya: Rp $totalCost", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: saveBorrow, child: const Text("Konfirmasi Pinjam"))),
            ]),
          ),
        ),
      ),
    );
  }
}
