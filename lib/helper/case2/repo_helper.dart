import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thiran/helper/case2/repository.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final databasePathWithName = join(databasePath, 'repositories.db');
    print('i reach here');
    // Check if the database file exists
    bool databaseExists = await databaseFactory.databaseExists(databasePathWithName);
    print('cehek database exist');
    // If the database file does not exist, create it
    if (!databaseExists) {
      print('Creating new database at: $databasePathWithName');

      // Open the database and create the repositories table
      final db = await openDatabase(databasePathWithName, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE repositories(id INTEGER PRIMARY KEY, name TEXT, description TEXT, stars INTEGER, ownerName TEXT, ownerAvatarUrl TEXT)');
          });

      return db;
    }

    // If the database file already exists, return it
    print('Opening existing database at: $databasePathWithName');
    return await openDatabase(databasePathWithName);
  }





  static Future<void> saveRepositories(List<Repository> repositories) async {
    final db = await initializeDatabase();
    for (var repo in repositories) {
      print(repo.name);
      await db.insert('repositories', repo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<List<Repository>> getRepositories() async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query('repositories');
    print('the lenght of database');
    print(maps.length);
    return List.generate(maps.length, (i) {
      return Repository(
          name: maps[i]['name'],
          description: maps[i]['description'] ?? "its not have description",
          stars: maps[i]['stars'] ?? 2,
          ownerName: maps[i]['ownerName'] ?? "No Name",
          ownerAvatarUrl: maps[i]['ownerAvatarUrl'] ?? "https://cdn.britannica.com/25/222725-050-170F622A/Indian-cricketer-Mahendra-Singh-Dhoni-2011.jpg");
    });
  }
}
