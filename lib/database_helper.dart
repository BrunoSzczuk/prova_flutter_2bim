import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = "EquipamentosDB.db";
  static final _dbVersion = 1;

  //Transforma a classe em Singleton para Gerenciar
  //as conexões do Banco
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database; //Retorna a Database instanciada
  }

  initDatabase() async {
    Directory dbDiretory = await getApplicationDocumentsDirectory();
    String path = join(dbDiretory.path, _dbName); //Monta o caminho da database
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE EQUIPAMENTOS 
                        (ID INTEGER PRIMARY KEY, 
                         NOME TEXT, 
                         NUM_ETIQUETA TEXT,
                         ATIVO BOOLEAN,
                         OBSERVACAO TEXT,
                         COR TEXT
                         )''');
  }

  //Metodo de Insert
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert("EQUIPAMENTOS", row);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    Database db = await instance.database;
    return await db.query("EQUIPAMENTOS");
  }

  Future<Map<String, dynamic>> getLast() async {
    Database db = await instance.database;
    var pessoas = await db.query("EQUIPAMENTOS", limit: 1, orderBy: "ID DESC");
    return pessoas.first;
  }

  Future<int> removerTodos() async {
    Database db = await instance.database;
    return await db.delete("EQUIPAMENTOS");
  }

  Future<int> remover(int id) async {
    Database db = await instance.database;
    return await db.delete("EQUIPAMENTOS", where: "ID = ?", whereArgs: [id]);
  }

  Future<int> update(Map<String, dynamic> row, int id) async {
    Database db = await instance.database;
    return await db.update("EQUIPAMENTOS", row, where: 'ID = ?', whereArgs: [id]);
  }
}
