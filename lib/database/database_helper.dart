import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // IMPORTANT: update version
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS borrow");
    await db.execute("DROP TABLE IF EXISTS users");
    await _createDB(db, newVersion);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
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
    ''');

    await db.execute('''
      CREATE TABLE borrow (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT,
        book_title TEXT,
        borrow_date TEXT,
        days INTEGER,
        total_cost INTEGER
      );
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  Future<int> insertBorrow(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('borrow', row);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getBorrowByUser(String userName) async {
    final db = await instance.database;
    return await db.query(
      'borrow',
      where: 'user_name = ?',
      whereArgs: [userName],
    );
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
