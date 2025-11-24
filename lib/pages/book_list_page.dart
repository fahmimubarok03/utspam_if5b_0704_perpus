import 'package:flutter/material.dart';
import '../models/book_model.dart'; // ← WAJIB ADA
import 'borrow_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Buku")),
      body: ListView.builder(
        itemCount: bookList.length, // ← buku dummy dari model
        itemBuilder: (context, index) {
          final book = bookList[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.asset(
                book.cover,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
              ),
              title: Text(book.title),
              subtitle: Text(book.genre),
              trailing: Text("Rp ${book.price}/hari"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BorrowPage(book: book),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
