class Book {
  final String title;
  final String genre;
  final int price;
  final String cover;
  final String synopsis;

  Book({
    required this.title,
    required this.genre,
    required this.price,
    required this.cover,
    required this.synopsis,
  });
}

// Dummy Data
List<Book> bookList = [
  Book(
    title: "Harry Potter and the Philosopher’s Stone",
    genre: "Fantasy",
    price: 10000,
    cover: "assets/hp1.jpg",
    synopsis: "Seorang anak yatim piatu mengetahui dirinya adalah seorang penyihir.",
  ),
  Book(
    title: "Laskar Pelangi",
    genre: "Drama",
    price: 8000,
    cover: "assets/laskar_pelangi.jpg",
    synopsis: "Perjalanan anak-anak Belitong dalam meraih impian melalui pendidikan.",
  ),
];
