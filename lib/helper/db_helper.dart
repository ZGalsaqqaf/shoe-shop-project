import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DbTables {
  static const String Categories = "Tests";
  static const String Cart = "Cart";
  // static const String ProductsTwo = "ProductsTwo";
}

class CartColumns {
  static const String cartId = "Id";
  static const String cartUserId = "User_id";
  static const String cartProductId = "Product_id";
  static const String cartPrice = "Price";
  static const String cartColor = "Color";
  static const String cartSize = "Size";
  static const String cartNumPieces = "Num_of_pieces";
  static const String cartImage = "Image";
  static const String cartDate = "Date";
  static const String cartIsSubmitted = "IsSubmitted";
}

// String _catrTbl =
//     'CREATE TABLE ${DbTables.Cart} (Id INTEGER PRIMARY KEY AUTOINCREMENT, ${CartColumns.cartUserId} TEXT, ${CartColumns.cartProductId} TEXT, ${CartColumns.cartPrice} REAL, Img TEXT, ${CartColumns.cartColor} TEXT, ${CartColumns.cartSize} INTEGER, ${CartColumns.cartNumPieces} INTEGER, ${CartColumns.cartDate} TEXT, ${CartColumns.cartIsSubmitted} INTEGER,)';

String _catrTbl = '''
CREATE TABLE ${DbTables.Cart} (
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  ${CartColumns.cartUserId} TEXT,
  ${CartColumns.cartProductId} TEXT,
  ${CartColumns.cartPrice} REAL,
  ${CartColumns.cartColor} TEXT,
  ${CartColumns.cartSize} INTEGER,
  ${CartColumns.cartNumPieces} INTEGER,
  ${CartColumns.cartImage} TEXT,
  ${CartColumns.cartDate} TEXT,
  ${CartColumns.cartIsSubmitted} INTEGER
)
''';

class DbHelper {
  static DbHelper? dbHelper;
  static Database? _database;

  DbHelper._createInstance();

  // prevant concorency, create an oject just one time, and then use the same obj
  factory DbHelper() {
    dbHelper ??= DbHelper._createInstance();
    return dbHelper as DbHelper;
  }

  Future<Database> _initializeDatabase() async {
    int dbVersion = 1;
    //// the first way : save files imbedded in the app, can't see it,( better to use it).
    // var path = getDatabasesPath();

    // the second way: can see the files
    final dbFolder = await getExternalStorageDirectory();
    // this external (path dbFolder!.path) add to it a new folder(directory) named "Databases".   // p => which is path package alias
    final dbPath = p.join(dbFolder!.path, "Databases");
    // the real create of the directory // recursive => if the file dirctory not found create it.
    Directory dbFolderDir = await Directory(dbPath).create(recursive: true);

    final file = File(p.join(dbFolderDir.path, 'lec5.db'));
    var testDb = await openDatabase(
        // اتصال بال DB
        file.path,
        version: dbVersion,
        onCreate: _createDatabaseV1,
        onDowngrade: onDatabaseDowngradeDelete // يحذف الذي تم اضافته
        );
    return testDb;
  }

  void _createDatabaseV1(Database db, int version) async {
    try {
      await db.execute(_catrTbl);
    } catch (e) {
      print("CreateExp:- " + e.toString());
      rethrow;
    }
  }

  Future<Database> get database async {
    // create database just one time
    _database ??= await _initializeDatabase();
    return _database as Database;
  }

  Future<List<Map<String, dynamic>>?> getAll(String tbl) async{
    try {
      Database db = await database;
      var res = await db.query(tbl);
      for(var item in res){
        print(item);
      }
      return res;
    } on Exception catch (e) {
      print("Exception in getAll: $e");
      return null;
    }
  } // end getAll

  Future<Map<String, dynamic>?> getById(String tableName, int id, {String pkName = "Id"}) async{
    try {
      Database db = await database;
      var result = await db.query(tableName, where: "$pkName = ?", whereArgs: [id]);
      return result.isNotEmpty ? result.first : null;
    } on Exception catch (e) {
      print("Exception in getById: $e");
      return null;
    }
  } // end getById

  Future<int> add(String tbl, Map<String, dynamic> obj) async{
    try {
      Database db = await database;
      print("db add: tbl = $tbl, obj = $obj");
      var res = await db.insert(tbl, obj, conflictAlgorithm: ConflictAlgorithm.ignore);
      return res;
    } on Exception catch (e) {
      print("Exception in Insert(add): $e");
      return 0;
    } 
  } // end add

  Future<int> update(String tbl, Map<String, dynamic> obj, {String pkName = 'Id'}) async{
    try {
      Database db = await database;
      var pkValue = obj[pkName];
      if(pkValue != null){
        var res = await db.update(tbl, obj, where: '$pkName = ?', whereArgs: [pkValue], conflictAlgorithm: ConflictAlgorithm.ignore);
        return res;
      }
      return 0;
    } on Exception catch (e) {
      print("Exception in update: $e");
      return 0;
    }
  }

  Future<int> delete(String tbl, Object pkValue, {String pkName = 'Id'}) async{
    try {
      Database db = await database;
      if(pkValue != null){
        var res = await db.delete(tbl, where: '$pkName = ?', whereArgs: [pkValue]);
        return res;
      }
      return 0;
    } on Exception catch (e) {
      print("Exception in delete: $e");
      return 0;
    }
  }

  
  

} // end DbaseHelper class
