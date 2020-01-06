import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter_liste_voeux/model/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseClient {

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await create();
      return _database;
    }
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');
    var bdd = await openDatabase(databaseDirectory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item (id INTEGER PRIMARY KEY, name TEXT NOT NULL)
    ''');
  }

  Future<Item> addItem(Item item) async {
    Database myDatabase = await database;
    item.id = await myDatabase.insert('item', item.toMap());
    return item;
  }

  Future<List<Item>> allItems() async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> results = await myDatabase.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    results.forEach((map) {
      Item item = Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

}