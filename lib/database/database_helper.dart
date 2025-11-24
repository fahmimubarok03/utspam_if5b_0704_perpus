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
      version: 10, // WAJIB UPDATE versi biar migrate DB
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
        name TEXT NOT NULL,
        nik TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE borrow (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT NOT NULL,
        book_title TEXT NOT NULL,
        cover TEXT NOT NULL,
        borrow_date TEXT NOT NULL,
        days INTEGER NOT NULL,
        total_cost INTEGER NOT NULL,
        status TEXT NOT NULL
      );
    ''');
  }

  // REGISTRASI
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  // LOGIN CEK USER
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  // INSERT PEMINJAMAN
  Future<int> insertBorrow(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('borrow', row);
  }

  // GET RIWAYAT SESUAI USER LOGIN
  Future<List<Map<String, dynamic>>> getBorrowByUser(String userName) async {
    final db = await instance.database;
    return await db.query(
      'borrow',
      where: 'user_name = ?',
      whereArgs: [userName],
    );
  }

  // UPDATE STATUS PEMINJAMAN → BATAL / SELESAI
  Future<int> updateBorrowStatus(int id, String newStatus) async {
    final db = await instance.database;
    return await db.update(
      'borrow',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // EDIT PEMINJAMAN
  Future<int> updateBorrowData(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'borrow',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
