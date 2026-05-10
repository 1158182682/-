import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:uuid/uuid.dart';

import '../../data/default_templates.dart';
import '../constants/app_constants.dart';

class AppDatabaseException implements Exception {
  final String message;
  final Object? cause;

  const AppDatabaseException(this.message, [this.cause]);

  @override
  String toString() => 'AppDatabaseException: $message';
}

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, AppConstants.dbName);
      return await openDatabase(
        path,
        version: AppConstants.dbVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      throw AppDatabaseException('初始化数据库失败', e);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id TEXT PRIMARY KEY,
        title TEXT,
        destination TEXT,
        start_date TEXT,
        end_date TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_items (
        id TEXT PRIMARY KEY,
        trip_id TEXT,
        category TEXT,
        title TEXT,
        note TEXT,
        quantity INTEGER,
        is_checked INTEGER,
        sort_order INTEGER,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE food_items (
        id TEXT PRIMARY KEY,
        trip_id TEXT,
        name TEXT,
        area TEXT,
        address TEXT,
        recommended_dish TEXT,
        budget REAL,
        actual_cost REAL,
        note TEXT,
        status TEXT,
        rating INTEGER,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE travel_notes (
        id TEXT PRIMARY KEY,
        trip_id TEXT,
        type TEXT,
        title TEXT,
        content TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_cards (
        id TEXT PRIMARY KEY,
        trip_id TEXT,
        name TEXT,
        emergency_contact_name TEXT,
        emergency_contact_phone TEXT,
        hotel_address TEXT,
        passport_number TEXT,
        insurance_phone TEXT,
        police_phone TEXT,
        ambulance_phone TEXT,
        embassy_phone TEXT
      )
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      final db = await database;
      return await db.insert(table, values);
    } catch (e) {
      throw AppDatabaseException('插入数据失败: $table', e);
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      throw AppDatabaseException('查询全部数据失败: $table', e);
    }
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    try {
      final db = await database;
      final result = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
      if (result.isEmpty) return null;
      return result.first;
    } catch (e) {
      throw AppDatabaseException('按 ID 查询失败: $table', e);
    }
  }

  Future<List<Map<String, dynamic>>> queryByTripId(String table, String tripId) async {
    try {
      final db = await database;
      return await db.query(table, where: 'trip_id = ?', whereArgs: [tripId]);
    } catch (e) {
      throw AppDatabaseException('按 trip_id 查询失败: $table', e);
    }
  }

  Future<int> updateById(String table, String id, Map<String, dynamic> values) async {
    try {
      final db = await database;
      return await db.update(table, values, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw AppDatabaseException('更新数据失败: $table', e);
    }
  }

  Future<int> deleteById(String table, String id) async {
    try {
      final db = await database;
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw AppDatabaseException('删除数据失败: $table', e);
    }
  }


  Future<void> createTripWithDefaultChecklist({
    required Map<String, dynamic> trip,
  }) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();
      final uuid = const Uuid();
      final tripId = trip['id'] as String?;
      if (tripId == null || tripId.isEmpty) {
        throw const AppDatabaseException('创建旅行失败: trip.id 不能为空');
      }

      await db.transaction((txn) async {
        await txn.insert('trips', trip);

        for (var i = 0; i < DefaultChecklistTemplates.overseasPreparationChecklist.length; i++) {
          final item = DefaultChecklistTemplates.overseasPreparationChecklist[i];
          await txn.insert('checklist_items', {
            'id': uuid.v4(),
            'trip_id': tripId,
            'category': item['category'],
            'title': item['title'],
            'note': '',
            'quantity': 1,
            'is_checked': 0,
            'sort_order': i,
            'created_at': now,
            'updated_at': now,
    

        for (final note in DefaultTravelNotesTemplates.defaultTravelNotes) {
          await txn.insert('travel_notes', {
            'id': uuid.v4(),
            'trip_id': tripId,
            'type': note['type'],
            'title': note['title'],
            'content': note['content'],
            'created_at': now,
            'updated_at': now,
          });
        }
      });
        }


        for (final note in DefaultTravelNotesTemplates.defaultTravelNotes) {
          await txn.insert('travel_notes', {
            'id': uuid.v4(),
            'trip_id': tripId,
            'type': note['type'],
            'title': note['title'],
            'content': note['content'],
            'created_at': now,
            'updated_at': now,
          });
        }
      });
    } catch (e) {
      if (e is AppDatabaseException) rethrow;
      throw AppDatabaseException('创建旅行并复制默认清单失败', e);
    }
  }

  Future<void> close() async {
    try {
      final db = _database;
      if (db != null) {
        await db.close();
        _database = null;
      }
    } catch (e) {
      throw AppDatabaseException('关闭数据库失败', e);
    }
  }
}
