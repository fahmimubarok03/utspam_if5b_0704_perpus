import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'borrow_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Buku")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          final book = bookList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(book.cover, width: 50, height: 70, fit: BoxFit.cover)),
              title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text("${book.genre}\nRp ${book.price}/hari", maxLines: 2),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BorrowPage(book: book)));
                },
                child: const Text("Pinjam"),
              ),
            ),
          );
        },
      ),
    );
  }
}
