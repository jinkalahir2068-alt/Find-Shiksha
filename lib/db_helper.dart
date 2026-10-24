import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'userinfo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)",
        );
      },
    );
  }

  // Insert data
  Future<int> insertData(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert('user', data);
  }

  // Fetch all data
  Future<List<Map<String, dynamic>>> getData() async {
    final dbClient = await db;
    return await dbClient.query('user');
  }
}