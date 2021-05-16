import 'dart:async';
import 'dart:core';



import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameAnuncioColumn = "nameAnuncioColumn";
final String clienteColumn = "clienteColumn";
final String dataInicioColumn = "dataInicioColumn";
final String dataTerminoColumn = "dataTerminoColumn";
final String diasColumn = "diasColumn";
final String valorFinalColumn ="valorFinalColumn";
final String maxViewColumn ="maxViewColumn";
final String maxClicColumn ="maxClicColumn";
final String maxSharesColumn ="maxSharesColumn";
final String valorDiaColumn = "valorDiaColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "anuncios.db");
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameAnuncioColumn TEXT,"
          "$clienteColumn TEXT, $dataInicioColumn TEXT, $dataTerminoColumn TEXT,$diasColumn TEXT, $valorFinalColumn INTEGER,"
              "$maxViewColumn NUMERIC, $maxClicColumn NUMERIC, $maxSharesColumn NUMERIC, $valorDiaColumn TEXT )");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContatac(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [
          idColumn,
          nameAnuncioColumn,
          clienteColumn,
          dataInicioColumn,
          dataTerminoColumn,
          diasColumn,
          valorFinalColumn,
          maxViewColumn,
          maxClicColumn,
          maxSharesColumn,
          valorDiaColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idColumn = ? ", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ? ", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Futuraclose()async{
    Database dbContact = await db;
    dbContact.close();


  }

}

class Contact {
  int id;
  String nameAnuncio;
  String cliente;
  String dataInicio;
  String dataTermino;
  String dias;
  int valorFinal;
  num maxView;
  num maxClic;
  num maxShares;
  String valorDia;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    nameAnuncio = map[nameAnuncioColumn];
    cliente = map[clienteColumn];
    dataInicio = map[dataInicioColumn];
    dataTermino = map[dataTerminoColumn];
    dias = map[diasColumn];
    valorFinal =map[valorFinalColumn];
    maxView = map[maxViewColumn];
    maxClic = map[maxClicColumn];
    maxShares = map[maxSharesColumn];
    valorDia = map[valorDiaColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameAnuncioColumn: nameAnuncio,
      clienteColumn: cliente,
      dataInicioColumn: dataInicio,
      dataTerminoColumn: dataTermino,
      diasColumn: dias,
      valorFinalColumn: valorFinal,
      maxViewColumn: maxView,
      maxClicColumn:maxClic,
      maxSharesColumn: maxShares,
      valorDiaColumn: valorDia,

    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $nameAnuncio, cliente: $cliente, inico: $dataInicio, "
        "termino: $dataTermino, dias: $dias, valorfinal: $valorFinal, maxview: $maxView, maxclic: $maxClic, maxshares: $maxShares valor: $valorDia)";
  }
}
