import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/data/models/task_model.dart';

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
        "todo" TEXT NOT NULL,
        "completed" BOOLEAN NOT NULL,
        "userId" INTEGER NOT NULL,
        "page_number" INTEGER NOT NULL,
        "total_pages" INTEGER NOT NULL
        )
        ''',
    );
  }

  //! GET TOTAL PAGES NUMBER
  Future<int> getTotalPages() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      'task_table',
      columns: ['total_pages'],
      distinct: true,
    );

    if (results.isNotEmpty) {
      final int totalPages = results.first['total_pages'];
      return totalPages;
    } else {
      return 0;
    }
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

  //! Get Tasks For A Page
  Future<List<Task>> getTasksForPage(int pageNumber) async {
    Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'task_table',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
    );

    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]['_id'],
        todo: maps[index]['todo'],
        completed: maps[index]['completed'] == 1,
        userId: maps[index]['userId'],
      );
    });
  }

  //!INSERT: ADD OBJECT
  Future<void> insertTasks(
      List<Task> tasks, int pageNumber, int totalPages) async {
    Database? db = await database;
    final batch = db!.batch();

    for (Task task in tasks) {
      batch.insert(
        'task_table',
        {
          'todo': task.todo,
          'completed': task.completed ? 1 : 0,
          'userId': task.userId,
          'page_number': pageNumber,
          'total_pages': totalPages,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  //!DELETE: DELETE OBJECT
  Future<int> deletetask(int id) async {
    Database? db = await database;

    int result =
        await db!.delete('task_table', where: '_id = ?', whereArgs: [id]);
    return result;
  }

  //!Drop Table
  Future<int> clearTable(String table_name) async {
    Database? db = await database;

    int result = await db!.delete(table_name);
    return result;
  }
}
