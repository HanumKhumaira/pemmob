
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();
    final gelap = prefs.getBool('tema_gelap') ?? false;

    if (!mounted) return;

    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _ubahTema(bool gelap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tema_gelap', gelap);

    if (!mounted) return;

    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: PengeluaranPage(
        temaGelap: _themeMode == ThemeMode.dark,
        onTemaChanged: _ubahTema,
      ),
    );
  }
}

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() {
    return {
      'nama': nama,
      'jumlah': jumlah,
      'kategori': kategori,
      'tanggal': tanggal,
    };
  }

  factory Pengeluaran.fromMap(Map<String, Object?> map) {
    return Pengeluaran(
      id: map['id'] as int,
      nama: map['nama'] as String,
      jumlah: map['jumlah'] as int,
      kategori: map['kategori'] as String,
      tanggal: map['tanggal'] as String,
    );
  }
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = p.join(
      await getDatabasesPath(),
      'pengeluaran.db',
    );

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pengeluaran (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah INTEGER NOT NULL,
            kategori TEXT NOT NULL,
            tanggal TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<List<Pengeluaran>> semua({
    bool terbaru = true,
    String kata = '',
  }) async {
    final db = await database;
    final pencarian = kata.trim();

    final data = await db.query(
      'pengeluaran',
      where: pencarian.isEmpty ? null : 'nama LIKE ?',
      whereArgs: pencarian.isEmpty ? null : ['%$pencarian%'],
      orderBy: terbaru ? 'tanggal DESC, id DESC' : 'tanggal ASC, id ASC',
    );

    return data.map(Pengeluaran.fromMap).toList();
  }

  static Future<int> tambah(Pengeluaran pengeluaran) async {
    final db = await database;
    return db.insert('pengeluaran', pengeluaran.toMap());
  }

  static Future<int> ubah(Pengeluaran pengeluaran) async {
    final db = await database;

    return db.update(
      'pengeluaran',
      pengeluaran.toMap(),
      where: 'id = ?',
      whereArgs: [pengeluaran.id],
    );
  }

  static Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'pengeluaran',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> total() async {
    final db = await database;

    final hasil = await db.rawQuery(
      'SELECT COALESCE(SUM(jumlah), 0) AS total FROM pengeluaran',
    );

    return (hasil.first['total'] as int?) ?? 0;
  }
}

class PengeluaranPage extends StatefulWidget {
  final bool temaGelap;
  final ValueChanged<bool> onTemaChanged;

  const PengeluaranPage({
    super.key,
    required this.temaGelap,
    required this.onTemaChanged,
  });

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  Future<List<Pengeluaran>> _future = DbHelper.semua();
  Future<int> _futureTotal = DbHelper.total();

  final TextEditingController _pencarian = TextEditingController();
  bool _terbaru = true;

  @override
  void initState() {
    super.initState();
    _muatPengaturanUrutan();
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  Future<void> _muatPengaturanUrutan() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _terbaru = prefs.getBool('urutan_terbaru') ?? true;
      _muat();
    });
  }

  void _muat() {
    _future = DbHelper.semua(
      terbaru: _terbaru,
      kata: _pencarian.text,
    );
    _futureTotal = DbHelper.total();
  }

  Future<void> _ubahUrutan(bool terbaru) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('urutan_terbaru', terbaru);

    if (!mounted) return;

    setState(() {
      _terbaru = terbaru;
      _muat();
    });
  }

  String _rupiah(int jumlah) {
    return 'Rp ${jumlah.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
    )}';
  }

  Future<void> _buka([Pengeluaran? pengeluaran]) async {
    final berhasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengeluaranPage(
          pengeluaran: pengeluaran,
        ),
      ),
    );

    if (berhasil == true && mounted) {
      setState(_muat);
    }
  }

  Future<void> _hapusPengeluaran(Pengeluaran pengeluaran) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus pengeluaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || pengeluaran.id == null) return;

    await DbHelper.hapus(pengeluaran.id!);

    if (mounted) {
      setState(_muat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
        actions: [
          IconButton(
            tooltip: widget.temaGelap ? 'Tema terang' : 'Tema gelap',
            icon: Icon(
              widget.temaGelap ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              widget.onTemaChanged(!widget.temaGelap);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<int>(
            future: _futureTotal,
            builder: (context, snapshot) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  title: const Text('Total Pengeluaran'),
                  subtitle: Text(
                    _rupiah(snapshot.data ?? 0),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _pencarian,
              decoration: const InputDecoration(
                labelText: 'Cari pengeluaran',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                setState(_muat);
              },
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              const Text('Urutan:'),
              const SizedBox(width: 12),
              DropdownButton<bool>(
                value: _terbaru,
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text('Terbaru'),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text('Terlama'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) _ubahUrutan(value);
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Pengeluaran>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Galat: ${snapshot.error}'),
                  );
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                    child: Text('Belum ada pengeluaran'),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return ListTile(
                      title: Text(item.nama),
                      subtitle: Text(
                        '${item.kategori} • ${item.tanggal}',
                      ),
                      onTap: () => _buka(item),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_rupiah(item.jumlah)),
                          PopupMenuButton<String>(
                            onSelected: (aksi) {
                              if (aksi == 'edit') {
                                _buka(item);
                              } else if (aksi == 'hapus') {
                                _hapusPengeluaran(item);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'hapus',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buka(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? pengeluaran;

  const FormPengeluaranPage({
    super.key,
    this.pengeluaran,
  });

  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nama;
  late final TextEditingController _jumlah;

  final List<String> _kategoriList = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Tagihan',
    'Lainnya',
  ];

  String? _kategori;
  DateTime _tanggal = DateTime.now();
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();

    final item = widget.pengeluaran;

    _nama = TextEditingController(text: item?.nama ?? '');
    _jumlah = TextEditingController(
      text: item?.jumlah.toString() ?? '',
    );

    if (item != null) {
      _kategori = item.kategori;
      _tanggal = DateTime.tryParse(item.tanggal) ?? DateTime.now();

      if (!_kategoriList.contains(_kategori)) {
        _kategoriList.add(_kategori!);
      }
    }
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (tanggal != null && mounted) {
      setState(() {
        _tanggal = tanggal;
      });
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _menyimpan = true;
    });

    try {
      final item = Pengeluaran(
        id: widget.pengeluaran?.id,
        nama: _nama.text.trim(),
        jumlah: int.parse(_jumlah.text.trim()),
        kategori: _kategori!,
        tanggal:
        '${_tanggal.year}-${_tanggal.month.toString().padLeft(2, '0')}-${_tanggal.day.toString().padLeft(2, '0')}',
      );

      if (widget.pengeluaran == null) {
        await DbHelper.tambah(item);
      } else {
        await DbHelper.ubah(item);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _menyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.pengeluaran == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          baru ? 'Tambah Pengeluaran' : 'Edit Pengeluaran',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final jumlah = int.tryParse(value?.trim() ?? '');

                if (jumlah == null || jumlah <= 0) {
                  return 'Jumlah harus berupa angka lebih dari 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _kategori = value;
                });
              },
              validator: (value) {
                if (value == null) return 'Pilih kategori';
                return null;
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                'Tanggal: ${_tanggal.day}/${_tanggal.month}/${_tanggal.year}',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _menyimpan ? null : _simpan,
              child: _menyimpan
                  ? const CircularProgressIndicator()
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
