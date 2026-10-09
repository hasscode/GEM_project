import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = await getDatabasesPath();

    return openDatabase(
      '$path/gem.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE guests(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            guestId TEXT UNIQUE,
            name TEXT,
            location TEXT,
            companions INTEGER,
            verified INTEGER
          )
        ''');
      },
    );
  }
}
