import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("library.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: (db, old, newV) async {
        await db.execute("DROP TABLE IF EXISTS borrow");
        await db.execute("DROP TABLE IF EXISTS users");
        _createDB(db, newV);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        nik TEXT UNIQUE,
        email TEXT UNIQUE,
        address TEXT,
        phone TEXT,
        username TEXT UNIQUE,
        password TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE borrow (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT,
        book_title TEXT,
        cover TEXT,
        borrow_date TEXT,
        days INTEGER,
        total_cost INTEGER,
        status TEXT
      );
    """);
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.insert('users', row);
  }

  Future<int> insertBorrow(Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.insert('borrow', row);
  }

  Future<int> updateBorrowData(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return db.update('borrow', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateBorrowStatus(int id, String status) async {
    final db = await instance.database;
    return db.update('borrow', {'status': status}, where: 'id=?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getBorrowByUser(String userName) async {
    final db = await instance.database;
    return db.query(
      'borrow',
      where: 'user_name=?',
      whereArgs: [userName],
    );
  }
}
