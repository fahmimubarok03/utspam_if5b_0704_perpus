import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/database/database_helper.dart';

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
    borrowDate = DateTime.parse(widget.data['borrow_date']);
    daysCtrl.text = widget.data['days'].toString();
    price = widget.data['total_cost'] ~/ widget.data['days'];
    calculateCost();
  }

  void calculateCost() {
    int days = int.tryParse(daysCtrl.text) ?? 0;
    setState(() {
      totalCost = (days > 0) ? days * price : 0;
    });
  }

  Future<void> updateBorrow() async {
    if (daysCtrl.text.isEmpty || int.tryParse(daysCtrl.text) == null || int.parse(daysCtrl.text) <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Lama pinjam tidak valid!")));
      return;
    }

    await DatabaseHelper.instance.updateBorrowData(widget.data['id'], {
      'borrow_date': DateFormat('yyyy-MM-dd').format(borrowDate!),
      'days': int.parse(daysCtrl.text),
      'total_cost': totalCost,
      'status': 'Aktif',
    });

    Navigator.pop(context, true); // ⬅️ mengirim signal update
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
            Text(
              widget.data['book_title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text("Tanggal Mulai:"),
            InkWell(
              onTap: () async {
                DateTime? pick = await showDatePicker(
                  context: context,
                  initialDate: borrowDate!,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2035),
                );
                if (pick != null) {
                  setState(() => borrowDate = pick);
                  calculateCost();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(DateFormat('yyyy-MM-dd').format(borrowDate!)),
              ),
            ),

            const SizedBox(height: 12),
            const Text("Lama Pinjam (hari):"),
            TextField(
              controller: daysCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (_) => calculateCost(),
            ),

            const SizedBox(height: 12),
            Text(
              "Total: Rp $totalCost",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: updateBorrow,
              child: const Text("Simpan Perubahan"),
            )
          ],
        ),
      ),
    );
  }
}
