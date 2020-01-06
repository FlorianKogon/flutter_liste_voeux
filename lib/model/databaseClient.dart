import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter_liste_voeux/model/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'article.dart';

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
    await db.execute('''
    CREATE TABLE article
    (id INTEGER PRIMARY KEY, name TEXT NOT NULL, item INTEGER, price TEXT, store TEXT, image TEXT)
    ''');
  }

  Future<Item> addItem(Item item) async {
    Database myDatabase = await database;
    item.id = await myDatabase.insert('item', item.toMap());
    return item;
  }

  Future<int> edit(Item item) async {
    Database myDatabase = await database;
    return myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<Item> upsertItem(Item item) async {
    Database myDatabase = await database;
    if (item.id == null) {
      item.id = await myDatabase.insert('item', item.toMap());
    } else {
      myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  Future<Article> upsertArticle(Article article) async {
    Database myDatabase = await database;
    (article.id == null) ? article.id = await myDatabase.insert('article', article.toMap())
        : await myDatabase.update('article', article.toMap(), where: 'id = ?', whereArgs: [article.id]);
  }

  Future<int> delete(int id, String table) async {
    Database myDatabase = await database;
    await myDatabase.delete('article', where: 'item = ?', whereArgs: [id]);
    return await myDatabase.delete(table, where: 'id = ?', whereArgs: [id]);
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

  Future<List<Article>> allArticles(int item) async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> results = await myDatabase.query('article', where: 'item = ?', whereArgs: [item]);
    List<Article> articles = [];
    results.forEach((map) {
      Article article = Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;
  }

}