// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final _dbname = 'myDatabase.db';
//   static final _dbversion = 1;

//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;

//     _database = await _initiateDatabase();
//     //this way we have to check if database is empty or not if it is than initiate function will be called or it will return database as it is.
//     return _database;
//     //than return database
//   }

//   _initiateDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, _dbname);
//     return await openDatabase(path, version: _dbversion, onCreate: _onCreate);
//   }

//   Future _onCreate(Database db, int version) async{
//     db.query(




//     );
//   }
// }
