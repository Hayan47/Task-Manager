import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/services/models/task_model.dart';

//!MAIN CLASS
class DatabaseHelper {
  static Database? _database;

  //!DATABASE GETTER
  Future<Database?> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
      return _database;
    }
    return _database;
  }

  //!INITIALIZE DATABASE
  Future<Database> initializeDatabase() async {
    //!get directory
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}tasks.db';
    Database mydatabase =
        await openDatabase(path, version: 1, onCreate: createTables);
    return mydatabase;
  }

  //!CREATE TABLE
  static Future<void> createTables(Database database, int newVersion) async {
    await database.execute(
      '''
        CREATE TABLE "task_table"(
        "_id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "first_name" TEXT NOT NULL,
        "last_name" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "avatar" TEXT NOT NULL)
        ''',
    );
  }

  //!CLOSE DATABASE
  Future closeDatabase() async {
    final db = await database;
    db!.close();
    // Directory directory = await getApplicationDocumentsDirectory();
    // String path = '${directory.path}tasks.db';
    // databaseFactory.deleteDatabase(path);
  }

  //!FETCH: GET ALL OBJECTS
  Future<List<Map<String, dynamic>>> gettasks() async {
    Database? db = await database;

    var result = await db!.query('task_table');
    return result;
  }

  //!INSERT: ADD OBJECT
  Future<int> addtask(Task task) async {
    Database? db = await database;

    var result = await db!.insert('task_table', task.toJson());
    return result;
  }

  //!DELETE: DELETE OBJECT
  Future<int> deletetask(int id) async {
    Database? db = await database;

    int result =
        await db!.delete('task_table', where: '_id = ?', whereArgs: [id]);
    return result;
  }

  //!ADD MULTIPLE TASKS
  Future<void> addTasks(List<Task> tasks) async {
    final db = await database;
    final batch = db!.batch();
    for (final task in tasks) {
      batch.insert('task_table', task.toJson());
    }
    await batch.commit();
  }

  // //GET NUMBER OF taskS
  // Future<int> gettasksCount() async {
  //   Database? db = await database;
  //   List<Map<String, dynamic>> x =
  //       await db!.rawQuery('SELECT COUNT (*) from task_table');
  //   int result = Sqflite.firstIntValue(x)!;
  //   return result;
  // }

  //CONVERT MAP INTO LIST OF taskS
  // Future<List<Task>> gettaskList() async {
  //   var tasksMapList = await gettasks();
  //   int count = tasksMapList.length;
  //   List<Task> tasksList = [];
  //   //for loop to add items to the list
  //   for (int i = 0; i < count; i++) {
  //     tasksList.add(Task.fromJson(tasksMapList[i]));
  //   }
  //   //or
  //   //tasksMapList.map((e) => task.fromMap(e)).toList();
  //   return tasksList;
  // }
}
