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
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        book.cover,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text(book.genre),
                            Text("Harga Pinjam: Rp ${book.price}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.synopsis,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BorrowPage(book: book),
                          ),
                        );
                      },
                      child: const Text("Pinjam"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
