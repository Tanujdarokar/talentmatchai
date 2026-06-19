import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mock_models.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('talentmatch_v2.db'); // Incremented version in name to force recreation
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        fullName TEXT,
        email TEXT,
        company TEXT,
        role TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE jobs (
        id TEXT PRIMARY KEY,
        title TEXT,
        department TEXT,
        type TEXT,
        experience TEXT,
        expRequiredMin INTEGER,
        status TEXT,
        applicantsCount INTEGER,
        requiredSkills TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE candidates (
        id TEXT PRIMARY KEY,
        name TEXT,
        role TEXT,
        experience TEXT,
        matchScore REAL,
        skills TEXT,
        photoUrl TEXT
      )
    ''');
  }

  // --- User Operations ---
  Future<void> saveUser(User user) async {
    final db = await instance.database;
    await db.insert('users', {
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'company': user.company,
      'role': user.role,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser() async {
    final db = await instance.database;
    final maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'] as String,
        fullName: maps[0]['fullName'] as String,
        email: maps[0]['email'] as String,
        company: maps[0]['company'] as String,
        role: maps[0]['role'] as String,
      );
    }
    return null;
  }

  // --- Job Operations ---
  Future<void> saveJobs(List<Job> jobs) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var job in jobs) {
      batch.insert('jobs', {
        'id': job.id,
        'title': job.title,
        'department': job.department,
        'type': job.type,
        'experience': job.experience,
        'expRequiredMin': job.expRequiredMin,
        'status': job.status,
        'applicantsCount': job.applicantsCount,
        'requiredSkills': job.requiredSkills.join(','),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Job>> getJobs({String? department}) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps;
    if (department != null && department != 'All') {
      maps = await db.query('jobs', where: 'department = ?', whereArgs: [department]);
    } else {
      maps = await db.query('jobs');
    }
    return List.generate(maps.length, (i) {
      return Job(
        id: maps[i]['id'] ?? '',
        title: maps[i]['title'] ?? '',
        department: maps[i]['department'] ?? '',
        type: maps[i]['type'] ?? '',
        experience: maps[i]['experience'] ?? '',
        expRequiredMin: maps[i]['expRequiredMin'] ?? 0,
        status: maps[i]['status'] ?? 'Open',
        applicantsCount: maps[i]['applicantsCount'] ?? 0,
        requiredSkills: (maps[i]['requiredSkills'] as String? ?? '').split(',').where((s) => s.isNotEmpty).toList(),
      );
    });
  }

  // --- Candidate Operations ---
  Future<void> saveCandidates(List<Candidate> candidates) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var c in candidates) {
      batch.insert('candidates', {
        'id': c.id,
        'name': c.name,
        'role': c.role,
        'experience': c.experience,
        'matchScore': c.matchScore,
        'skills': c.skills.join(','),
        'photoUrl': c.photoUrl,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Candidate>> getCandidates({String? sortBy, String? search}) async {
    final db = await instance.database;
    String? where;
    List<dynamic>? whereArgs;
    
    if (search != null && search.isNotEmpty) {
      where = 'name LIKE ?';
      whereArgs = ['%$search%'];
    }

    String orderBy = 'matchScore DESC';
    if (sortBy == '-createdAt') orderBy = 'id DESC';

    final List<Map<String, dynamic>> maps = await db.query(
      'candidates',
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return List.generate(maps.length, (i) {
      return Candidate(
        id: maps[i]['id'] ?? '',
        name: maps[i]['name'] ?? '',
        role: maps[i]['role'] ?? '',
        experience: maps[i]['experience'] ?? '',
        matchScore: (maps[i]['matchScore'] ?? 0.0).toDouble(),
        skills: (maps[i]['skills'] as String? ?? '').split(',').where((s) => s.isNotEmpty).toList(),
        photoUrl: maps[i]['photoUrl'] ?? '',
      );
    });
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('users');
    await db.delete('jobs');
    await db.delete('candidates');
  }
}
