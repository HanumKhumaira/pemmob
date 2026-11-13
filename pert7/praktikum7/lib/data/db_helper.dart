import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';

final ValueNotifier<int> versiData = ValueNotifier<int>(0);

class DbHelper {
  static Database? _db;

  static Future<Database> get _database async {
    if (_db != null) return _db!;

    final pathDb = join(
      await getDatabasesPath(),
      'tabungku.db',
    );

    _db = await openDatabase(
      pathDb,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kegiatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL,
            tipe TEXT NOT NULL,
            nominal INTEGER NOT NULL,
            kategori TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<List<Kegiatan>> pada(String tanggal) async {
    final db = await _database;

    final hasil = await db.query(
      'kegiatan',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );

    return hasil.map((e) => Kegiatan.fromMap(e)).toList();
  }

  static Future<int> tambah(Kegiatan kegiatan) async {
    final db = await _database;

    final data = kegiatan.toMap();
    data.remove('id');

    final id = await db.insert(
      'kegiatan',
      data,
    );

    versiData.value++;

    return id;
  }

  static Future<int> ubah(Kegiatan kegiatan) async {
    final db = await _database;

    final hasil = await db.update(
      'kegiatan',
      kegiatan.toMap(),
      where: 'id = ?',
      whereArgs: [kegiatan.id],
    );

    versiData.value++;

    return hasil;
  }

  static Future<int> hapus(int id) async {
    final db = await _database;

    final hasil = await db.delete(
      'kegiatan',
      where: 'id = ?',
      whereArgs: [id],
    );

    versiData.value++;

    return hasil;
  }

  static Future<Ringkasan> ringkasan(String tanggal) async {
    final db = await _database;

    final hasil = await db.rawQuery('''
      SELECT COUNT(*) AS jumlah,
           COALESCE(SUM(selesai), 0) AS selesai,
           COALESCE(SUM(CASE WHEN tipe = 'pemasukan'
                             THEN nominal END), 0) AS masuk,
           COALESCE(SUM(CASE WHEN tipe = 'pengeluaran'
                             THEN nominal END), 0) AS keluar
    FROM kegiatan
    WHERE tanggal = ?
  ''', [tanggal]);

    final baris = hasil.first;

    return Ringkasan(
      jumlahKegiatan: baris['jumlah'] as int,
      selesai: baris['selesai'] as int,
      pemasukan: baris['masuk'] as int,
      pengeluaran: baris['keluar'] as int,
    );
  }
}