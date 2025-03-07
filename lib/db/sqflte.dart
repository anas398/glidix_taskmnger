import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/model/task_model.dart';

class SQLiteHelper {
  static const String _tableName = 'tasks';

  // Create SQLite Database
  static Future<Database> _openDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDocDir.path, 'tasks.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT,
          priority TEXT,
          status TEXT,
          endDate TEXT
        )
      ''');
    });
  }

  // Export tasks to SQLite file
  static Future<void> exportTasksToSQLite(List<TaskModel> tasks) async {
    final db = await _openDatabase();
    await db.transaction((txn) async {
      await txn.delete(_tableName); // Clear existing data
      for (var task in tasks) {
        await txn.insert(_tableName, {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'priority': task.priority,
          'status': task.status,
          'endDate': task.endDate.toIso8601String(),
        });
      }
    });
    await db.close();
  }

  // Import tasks from SQLite file
  static Future<List<TaskModel>> importTasksFromSQLite() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> taskMaps = await db.query(_tableName);
    await db.close();

    return taskMaps.map((task) {
      return TaskModel(
        id: task['id'],
        title: task['title'],
        description: task['description'],
        priority: task['priority'],
        status: task['status'],
        endDate: DateTime.parse(task['endDate']),
      );
    }).toList();
  }

  // Export SQLite database file to external storage
  static Future<String?> exportDatabaseFile() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'tasks.db');
      final exportDir = Directory('/storage/emulated/0/Download');
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }
      final exportPath = join(exportDir.path, 'tasks_export.db');
      await File(dbPath).copy(exportPath);
      return exportPath;
    } catch (e) {
      print('Export error: $e');
      return null;
    }
  }
}
