import 'dart:io';

import 'package:flyflutter_fast_start/model/placemark_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();

  static const String DB_NAME = "flutter_weather.db";

  static const String PLACES_TABLE_NAME = "Places";

  static const String CREATE_PLACES_TABLE = "CREATE TABLE $PLACES_TABLE_NAME ("
      "id INTEGER PRIMARY KEY,"
      "name TEXT,"
      "isoCountryCode TEXT,"
      "country TEXT,"
      "postalCode TEXT,"
      "administrativeArea TEXT,"
      "subAdministrativeArea TEXT,"
      "locality TEXT,"
      "longitude REAL,"
      "latitude REAL,"
      "timestamp INTEGER"
      ")";

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(CREATE_PLACES_TABLE);
    });
  }

  /// добавление места
  addPlace(Placemark placemark) async {
    final db = await database;
    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM $PLACES_TABLE_NAME");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into $PLACES_TABLE_NAME (id, name, isoCountryCode, country, postalCode, "
        "administrativeArea, subAdministrativeArea, longitude, latitude, timestamp)"
        " VALUES (?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          placemark.name,
          placemark.isoCountryCode,
          placemark.country,
          placemark.postalCode,
          placemark.administrativeArea,
          placemark.subAdministrativeArea,
          placemark.position?.longitude,
          placemark.position?.latitude,
          placemark.position?.timestamp?.millisecondsSinceEpoch
        ]);
    return raw;
  }

  /// обновление места
  updatePlacemark(PlacemarkLocal newPlacemark) async {
    final db = await database;
    var res = await db.update(PLACES_TABLE_NAME, newPlacemark.toMap(),
        where: "id = ?", whereArgs: [newPlacemark.id]);
    return res;
  }

  /// получение места
  getPlacemark(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? PlacemarkLocal.fromMap(res.first) : null;
  }

  /// получение списка всех мест
  Future<List<PlacemarkLocal>> getAllPlacemarks() async {
    final db = await database;
    var res = await db.query(PLACES_TABLE_NAME);
    List<PlacemarkLocal> list = res.isNotEmpty
        ? res.map((c) => PlacemarkLocal.fromMap(c)).toList()
        : [];
    return list;
  }

  /// удаление места
  deletePlacemark(int id) async {
    final db = await database;
    return db.delete(PLACES_TABLE_NAME, where: "id = ?", whereArgs: [id]);
  }
}
