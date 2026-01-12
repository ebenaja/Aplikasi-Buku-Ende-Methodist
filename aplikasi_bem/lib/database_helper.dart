import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // GANTI NAMA DB JADI V4 (Agar database lama terhapus & buat baru)
    _database = await _initDB('buku_ende_local_v4.db'); 
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number INTEGER,
        title TEXT,
        lyrics TEXT,
        category TEXT,
        key_note TEXT
      )
    ''');

    print("🚀 MEMULAI IMPORT DATA DARI MARKDOWN...");
    await _importFromMarkdown(db);
  }

  Future<void> _importFromMarkdown(Database db) async {
    try {
      // --- PERBAIKAN DI SINI (Cara Resmi Flutter Terbaru) ---
      // Kita tidak membaca 'AssetManifest.json' manual lagi.
      // Kita pakai class AssetManifest bawaan Flutter Services.
      final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      
      // Ambil semua daftar file aset
      final List<String> assets = assetManifest.listAssets();

      // Filter hanya yang ada di folder BEM_teks
      final filePaths = assets
          .where((String key) => key.contains('assets/BEM/BEM_teks/') && key.endsWith('.md'))
          .toList();

      if (filePaths.isEmpty) {
        print("⚠️ PERINGATAN: Folder assets/BEM/BEM_teks/ kosong atau tidak terdaftar di pubspec.yaml");
        return;
      }

      Batch batch = db.batch();

      for (String path in filePaths) {
        // Ambil nama file & dekode URL (jika ada %20)
        String filename = path.split('/').last; 
        filename = Uri.decodeFull(filename).replaceAll('.md', '');

        // Regex: Ambil Angka & Judul
        final RegExp regex = RegExp(r'^(\d+)\.\s*(.*)'); 
        final match = regex.firstMatch(filename);

        if (match != null) {
          int number = int.parse(match.group(1)!);
          String title = match.group(2)!;
          
          // Baca isi file
          String content = await rootBundle.loadString(path);
          
          batch.insert('songs', {
            'number': number,
            'title': title,
            'lyrics': content.trim(),
            'category': 'Umum', 
            'key_note': null
          });
        }
      }

      await batch.commit();
      print("✅ SUKSES IMPORT! Total ${filePaths.length} lagu masuk database.");

    } catch (e) {
      print("❌ ERROR SAAT IMPORT: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllSongs() async {
    final db = await instance.database;
    return await db.query('songs', orderBy: 'number ASC');
  }

  Future<List<Map<String, dynamic>>> searchSongs(String keyword) async {
    final db = await instance.database;
    return await db.query(
      'songs',
      where: 'title LIKE ? OR number LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'number ASC',
    );
  }
}