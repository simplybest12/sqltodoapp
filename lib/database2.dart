import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLhelper {
  static final _dbname = 'mydatabase.db';
  static final _dbversion = 1;
  static final _table = 'dbTable';
  static final columnId = '_id';
  static final columnDescription = 'name';
  static final columntitle = 'title';

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
    CREATE TABLE $_table(
      $columnId INT PRIMARY KEY AUTOINCREMENT NOT NULL,
      $columntitle TEXT,
      $columnDescription TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    ''');
  }

  //this method helps to create a table if not exist and if exist it will open the file
  static Future<sql.Database> db() async {
    return sql.openDatabase(_dbname, version: _dbversion,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //this method helps to insert in table
  static Future<int> createItem(String title, String? description) async {
    //object creation
    final db = await SQLhelper.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,
        //this is for good practice
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //this method will run when we will start or reload our app and also it will help in read operation as one data or whole data
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLhelper.db();
    return db.query('items', orderBy: 'id');
  }

  //this method is responsible fr getting one item at a time
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLhelper.db();
    return db.query('items',
        where: "id=?",
        whereArgs: [id],
        limit: 1); //question mark ki vale arg me define hga
  }

  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await SQLhelper.db();
    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('items', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLhelper.db();
    try {
      await db.delete('item', where: 'id=?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
