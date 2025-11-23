import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BorrowPage extends StatelessWidget {
  final Book book;

  const BorrowPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pinjam Buku")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Judul: ${book.title}"),
            Text("Genre: ${book.genre}"),
            Text("Harga Pinjam: Rp ${book.price}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // nanti tambah database peminjaman
              },
              child: const Text("Konfirmasi Pinjam"),
            )
          ],
        ),
      ),
    );
  }
}
