import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class TaxaDatabase {
  int _idTaxa = 1;
  late final double _taxa;

  Future<Database> createTaxaDatabase() {
    return getDatabasesPath().then((db) {
      final String path = join(db, 'contadeluz1.db');
      return openDatabase(path, onCreate: (db, version) {
        db.execute('CREATE TABLE taxa(id INTEGER PRIMARY KEY, taxa DOUBLE);');
      }, version: 2)
          .then((value) {
        value.rawInsert('INSERT OR IGNORE INTO taxa (id, taxa) VALUES(?,?);',
            [_idTaxa, 1.17]);
        print(value);
        return value;
      });
    });
  }

  void saveTaxa(double taxa) {
    createTaxaDatabase().then((db) {
      final Map<String, dynamic> mapTaxa = Map();

      mapTaxa['id'] = 1;
      mapTaxa['taxa'] = taxa;

      db.update('taxa', mapTaxa, where: 'id=?', whereArgs: [1]);
    });
  }

  Future<double> getTaxa() {
    return createTaxaDatabase().then((db) {
      return db.query('taxa').then((value) {
        double taxa = 0;

        for (Map<String, dynamic> map in value) {
          taxa = map['taxa'];
        }

        debugPrint(taxa.toString());
        return taxa;
      });
    });
  }
}
