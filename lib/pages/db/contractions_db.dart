// @dart=2.9
import 'dart:async';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContractionsDb {
  static final ContractionsDb _instance = ContractionsDb.internal();

  factory ContractionsDb() => _instance;

  final String dbName = 'empatbulan.db';
  final String tableName = 'contractions';
  final String columnId = 'id';
  final String columnStart = 'start';
  final String columnDuration = 'duration';
  final String columnInterval = 'interval';

  static Database _db;

  ContractionsDb.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);
    var db = await openDatabase(path, version: 1);
    await db.execute('create table IF NOT EXISTS $tableName('
        '$columnStart varchar(30) primary key, '
        '$columnDuration varchar(10), '
        '$columnInterval varchar(10))');
    return db;
  }

  Future<List> insert(String start, String duration, String interval) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'INSERT INTO $tableName ($columnStart, $columnDuration, $columnInterval) '
        'VALUES ("$start", "$duration", "$interval")');
    return result.toList();
  }

  Future<List> list(String today) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName '
        'WHERE SUBSTR($columnStart, 1, 11) = "$today"');
    return result.toList();
  }

  Future<List> group() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT SUBSTR($columnStart, 1, 11) AS contractionDay '
        'FROM $tableName '
        'GROUP BY contractionDay ORDER BY contractionDay DESC');
    return result.toList();
  }

  del() async {
    String thisDay = DateFormat('d MMM yyyy HH:mm:ss', 'id_ID').format(DateTime.now()).substring(0, 11);
    var dbClient = await db;
    var result = await dbClient.rawDelete('DELETE FROM $tableName WHERE SUBSTR($columnStart, 1, 11) = "$thisDay"');
    return result;
  }
}