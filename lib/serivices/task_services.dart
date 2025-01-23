import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskService {
  Database? _database;  // Change from 'late' to nullable

  // Initialize the database
  Future<void> initialize() async {
    if (_database != null) return; // Check if the database is already initialized

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'task_manager.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    await initialize();  // Ensure database is initialized
    final List<Map<String, dynamic>> maps = await _database!.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> insertTask(Task task) async {
    await initialize();
    await _database!.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    await initialize();
    await _database!.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    await initialize();
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleTaskCompletion(int id) async {
    await initialize();
    final task = await getTaskById(id);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<Task> getTaskById(int id) async {
    await initialize();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    throw Exception('Task not found');
  }
}
  