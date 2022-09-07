// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/attendance_model.dart';

class AttDatabase {
  static final AttDatabase instance = AttDatabase._init();

  static Database? _database;

  AttDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'DOUBLE NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
    CREATE TABLE $tableAttendances (
      ${AttendanceFields.id} $idType,
      ${AttendanceFields.name} $textType,
      ${AttendanceFields.latitude} $doubleType,
      ${AttendanceFields.longitude} $doubleType,
      ${AttendanceFields.createdAt} $textType
    )
    ''');
  }

  Future<AttendanceModel> create(AttendanceModel attendance) async {
    final db = await instance.database;

    final id = await db.insert(tableAttendances, attendance.toJson());
    return attendance.copy(id: id);
  }

  Future<AttendanceModel> readAttendance(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableAttendances,
      columns: AttendanceFields.values,
      where: '${AttendanceFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AttendanceModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<AttendanceModel>> readAllAttendances() async {
    final db = await instance.database;

    const orderBy = '${AttendanceFields.createdAt} DESC';
    final result = await db.query(tableAttendances, orderBy: orderBy);

    return result.map((json) => AttendanceModel.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
