import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;
  static final _databaseVersion = 1;
  static final String id = '_id';
  static final String _databaseName = 'InstaPost.db';
  static final String table = 'PendingPost';
  static final String text = 'comment';
  static final String hashTags = 'hashtag';
  static final String picture = 'picture';
  static final String emailCol = 'email';

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $id  INTEGER PRIMARY KEY,
            $text TEXT NOT NULL,
            $hashTags TEXT NOT NULL,
            $picture TEXT NOT NULL,
            $emailCol TEXT NOT NULL
            
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryForAnEmail(String email) async {
    Database db = await instance.database;
    return await db.query(table, where: '$emailCol = ?', whereArgs: [email]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['_id'];
    return await db.update(table, row, where: '$id = ?', whereArgs: [id]);
  }

  Future close() async {
    return instance.close();
  }
}
