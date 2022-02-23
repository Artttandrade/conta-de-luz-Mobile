import 'package:conta_de_luz/models/Conta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then((db) {
    final String path = join(db, 'contadeluz.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE contas('
          'id INTEGER PRIMARY KEY, '
          'numero_contador TEXT, '
          'valor TEXT, '
          'mes TEXT);');
    }, version: 1)
        .then((value) {
      print(value);
      return value;
    });
  });
}

Future<int> saveConta(Conta conta) {
  return createDatabase().then((db) {
    final Map<String, dynamic> mapContas = Map();
    mapContas['numero_contador'] = conta.numeroConta;
    mapContas['valor'] = conta.valor;
    mapContas['mes'] = conta.mes;
    return db.insert('contas', mapContas);
  });
}

Future<List<Conta>> findAllContas() {
  return createDatabase().then((db) {
    return db
        .query(
      'contas',
      orderBy: 'id DESC',
    )
        .then((value) {
      List<Conta> contas = [];

      for (Map<String, dynamic> map in value) {
        Conta conta = Conta.all(
          map['id'],
          map['numero_contador'],
          map['valor'],
          map['mes'],
        );
        contas.add(conta);
      }
      return contas;
    });
  });
}

void editConta(Conta conta) {
  createDatabase().then((db) {
    final Map<String, dynamic> map = Map();
    map['id'] = conta.id;
    map['numero_contador'] = conta.numeroConta;
    map['valor'] = conta.valor;
    map['mes'] = conta.mes;
    print('id: ' + conta.id.toString());

    db.update('contas', map, where: 'id=?', whereArgs: [conta.id]).then(
        (value) async {
      findAllContas().then((value) => print(value[0].mes));
    });
  });
}

void deleteConta(Conta conta) {
  createDatabase().then((value) {
    value.delete('contas', where: 'id =?', whereArgs: [conta.id]);
  });
}
