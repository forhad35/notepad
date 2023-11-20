import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
var table = "notes";
class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // If _database is null, initialize it
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'myDatabase.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table when the database is created
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            createDate TEXT,
            modifyDate TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertData(String table, Map<String, dynamic> data) async {
    final Database db = await database;

    // Insert the data into the table
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  static Future<List<Map<String, dynamic>>> searchData(String searchString) async {
    final Database db = await database;
    return db.rawQuery('''
    SELECT * FROM $table WHERE name LIKE '%$searchString%' OR description LIKE '%$searchString%'
    ''');
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final Database db = await database;
    // Query the table for all records
    return await db.query(table);
  }

  static Future<int> updateData(String table, Map<String, dynamic> data,int id) async {
    final Database db = await database;
    // Update the data in the table
    return await db.update(
      table,
      data,
      where: 'id = $id',
      // assuming 'id' is the primary key
    );
  }
  static Future dropTable (String table) async{
    final Database db = await database;
    return await db.delete(table);
  }
  static Future deleteData(String table,  id) async {
    final Database db = await database;
    return await db.rawDelete("DELETE FROM $table WHERE id IN ($id)");
  }
}
