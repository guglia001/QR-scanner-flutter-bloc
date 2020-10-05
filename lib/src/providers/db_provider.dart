import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_menu_scanner/src/model/scanmodel.dart';
export  'package:restaurant_menu_scanner/src/model/scanmodel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database; //para saber si esta inicializada

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directorio = await getApplicationDocumentsDirectory();
    final path = join(directorio.path, 'Scans.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Scans ("
          " id INTEGER PRIMARY KEY,"
          " url TEXT,"
          " titulo TEXT"
          ")"
          );
    });
  }

  //crear registros

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }

  // SELECT - obtener info

  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;
  }

  Future<List<ScanModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db.query("Scans");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  // ELIMINAR REGISTROS

 Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
