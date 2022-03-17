import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zadatak/models/comment_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'zadatak.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE comments(id INTEGER PRIMARY KEY AUTOINCREMENT, postId INTEGER NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL, body TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertComments(Comment comment) async {
    final db = await database;

    await db.insert('comments', comment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Comment>> getComments() async {
    final db = await database;
    var res = await db.query("comments");
    List<Comment> list =
        res.isNotEmpty ? res.map((c) => Comment.fromJson(c)).toList() : [];

    return list;
  }
}
