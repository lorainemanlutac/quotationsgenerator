import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotationsgenerator/models/QuotationModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MLKJDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE quotation ('
          'id INTEGER PRIMARY KEY,'
          'email_address TEXT,'
          'project TEXT,'
          'location TEXT,'
          'particulars TEXT,'
          'note TEXT,'
          'created_date TEXT,'
          'changed_date TEXT'
          ')');
    });
  }

  getAllQuotationsModel() async {
    final db = await database;
    var res = await db!.query('quotation');
    List<QuotationModel> list = res.isNotEmpty
        ? res.map((c) => QuotationModel.fromMap(c)).toList()
        : [];

    return list;
  }

  newQuotationModel(QuotationModel newQuotationModel) async {
    final db = await database;
    var table = await db!.rawQuery('SELECT MAX(id)+1 as id FROM quotation');
    var id = table.first['id'];

    id = id == null ? 1 : id as int;

    var raw = await db.rawInsert(
        'INSERT Into quotation ('
        'id,'
        'email_address,'
        'project,'
        'location,'
        'particulars,'
        'note,'
        'created_date,'
        'changed_date'
        ')'
        ' VALUES (?,?,?,?,?,?,?,?)',
        [
          id,
          newQuotationModel.emailAddress,
          newQuotationModel.project,
          newQuotationModel.location,
          newQuotationModel.particulars,
          newQuotationModel.note,
          newQuotationModel.createdDate,
          newQuotationModel.changedDate
        ]);

    return raw;
  }
}
