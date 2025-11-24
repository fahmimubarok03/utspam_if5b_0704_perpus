import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class EditBorrowPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditBorrowPage({super.key, required this.data});

  @override
  State<EditBorrowPage> createState() => _EditBorrowPageState();
}

class _EditBorrowPageState extends State<EditBorrowPage> {
  TextEditingController daysCtrl = TextEditingController();
  DateTime? borrowDate;
  late int price;
  int totalCost = 0;

  @override
  void initState() {
    super.initState();

    borrowDate = DateTime.tryParse(widget.data['borrow_date']) ?? DateTime.now();
    daysCtrl.text = widget.data['days'].toString();

    /// Hitung harga per hari kembali dari total
    price = widget.data['total_cost'] ~/ widget.data['days'];

    calculateCost();
  }

  /// Hitung total biaya real-time
  void calculateCost() {
    int days = int.tryParse(daysCtrl.text) ?? 0;
    if (days > 0) {
      setState(() => totalCost = days * price);
    } else {
      setState(() => totalCost = 0);
    }
  }

  /// Update peminjaman ke database
  Future<void> updateBorrow() async {
    if (daysCtrl.text.isEmpty || int.tryParse(daysCtrl.text) == null || int.parse(daysCtrl.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Lama pinjam harus angka > 0"),
      ));
      return;
    }

    await DatabaseHelper.instance.updateBorrowData(widget.data['id'], {
      'borrow_date': DateFormat('yyyy-MM-dd').format(borrowDate!),
      'days': int.parse(daysCtrl.text),
      'total_cost': totalCost,
      'status': widget.data['status'], // status TIDAK dipaksa berubah
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Data peminjaman berhasil diperbarui!"),
    ));

    Navigator.pop(context, true); // untuk refresh halaman history
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Peminjaman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.data['book_title'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            const Text("Tanggal Mulai:"),
            InkWell(
              onTap: () async {
                final picking = await showDatePicker(
                  context: context,
                  initialDate: borrowDate!,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2035),
                );
                if (picking != null) {
                  setState(() => borrowDate = picking);
                  calculateCost();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(DateFormat('yyyy-MM-dd').format(borrowDate!)),
              ),
            ),
            const SizedBox(height: 12),

            const Text("Lama Pinjam (hari):"),
            TextField(
              controller: daysCtrl,
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateCost(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan lama peminjaman",
              ),
            ),
            const SizedBox(height: 12),

            Text("Total Biaya : Rp $totalCost",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateBorrow,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Simpan Perubahan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
