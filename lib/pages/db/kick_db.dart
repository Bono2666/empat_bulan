// @dart=2.9
import 'dart:async';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KickDb {
  static final KickDb _instance = KickDb.internal();

  factory KickDb() => _instance;

  final String dbName = 'empatbulan.db';
  final String tableName = 'kick';
  final String columnTime = 'time';
  final String columnMove = 'move';
  final String columnColor = 'color';
  final String columnDay = 'kickdate';

  static Database _db;

  KickDb.internal();

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
        '$columnTime varchar(30) primary key, '
        '$columnMove varchar(30), '
        '$columnColor varchar(50), '
        '$columnDay varchar(30))');
    return db;
  }

  Future<List> insert(String time, String move, String color, String kickdate) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'INSERT INTO $tableName ($columnTime, $columnMove, $columnColor, $columnDay) '
        'VALUES ("$time", "$move", "$color", "$kickdate")');
    return result.toList();
  }

  Future<List> list(String today) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $tableName '
        'WHERE SUBSTR($columnTime, 1, 11) = "$today"');
    return result.toList();
  }

  Future<List> group() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT SUBSTR($columnTime, 1, 11) AS kickDay, COUNT(SUBSTR($columnTime, 1, 11)) AS kickCount, color, kickdate '
        'FROM $tableName '
        'GROUP BY kickDay ORDER BY kickDay DESC');
    return result.toList();
  }

  del() async {
    String thisDay = DateFormat('d MMM yyyy HH:mm:ss', 'id_ID').format(DateTime.now()).substring(0, 11);
    var dbClient = await db;
    var result = await dbClient.rawDelete('DELETE FROM $tableName WHERE SUBSTR($columnTime, 1, 11) = "$thisDay"');
    return result;
  }
}