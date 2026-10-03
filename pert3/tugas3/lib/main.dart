import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => DaftarBelanjaModel(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 3',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const DaftarBelanjaPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _controller = TextEditingController();
  String _salam = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Dasar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _salam = 'Halo, ${_controller.text}!');
              },
              child: const Text('Sapa'),
            ),
            const SizedBox(height: 12),
            Text(_salam, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarang = TextEditingController();
  final _jumlah = TextEditingController();

  String? _kategori;
  bool _setuju = false;

  @override
  void dispose() {
    _namaBarang.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  void _kirim() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terdaftar: ${_namaBarang.text} ($_kategori)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Tambah Barang')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaBarang,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final jumlah = int.tryParse(v ?? '');
                if (jumlah == null || jumlah <= 0) {
                  return 'Jumlah harus lebih dari 0!';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Makanan',
                  child: Text('Makanan'),
                ),
                DropdownMenuItem(
                  value: 'Minuman',
                  child: Text('Minuman'),
                ),
                DropdownMenuItem(
                  value: 'Kebutuhan Rumah',
                  child: Text('Kebutuhan Rumah'),
                ),
              ],
              onChanged: (v) => setState(() => _kategori = v),
              validator: (v) => v == null ? 'Pilih Kategori!' : null,
            ),
            CheckboxListTile(
              title: const Text('Saya setuju mendaftarkan barang'),
              value: _setuju,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (v) => setState(() => _setuju = v ?? false),
            ),
            ElevatedButton(
              onPressed: _setuju ? _kirim : null,
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DaftarBelanja {
  String namaBarang;
  int jumlah;
  String kategori;
  bool sudahDibeli;

  DaftarBelanja(
      this.namaBarang,
      this.jumlah,
      this.kategori, {
        this.sudahDibeli = false,
      });
}

class DaftarBelanjaModel extends ChangeNotifier {
  final List<DaftarBelanja> _items = [];

  List<DaftarBelanja> get items => List.unmodifiable(_items);

  int get jumlahBelumDibeli =>
      _items.where((t) => !t.sudahDibeli).length;

  void tambah(String namaBarang, int jumlah, String kategori) {
    _items.add(DaftarBelanja(namaBarang, jumlah, kategori));
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].sudahDibeli = !_items[index].sudahDibeli;
    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void hapusSelesai() {
    _items.removeWhere((t) => t.sudahDibeli);
    notifyListeners();
  }
}

class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DaftarBelanjaModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Belanja (${model.jumlahBelumDibeli})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<DaftarBelanjaModel>().hapusSelesai();
            },
          ),
        ],
      ),
      body: model.items.isEmpty
          ? const Center(
        child: Text('Belum ada barang!'),
      )
          : ListView.builder(
        itemCount: model.items.length,
        itemBuilder: (context, i) {
          final t = model.items[i];

          return ListTile(
            key: ValueKey(t.namaBarang),
            leading: Checkbox(
              value: t.sudahDibeli,
              onChanged: (_) => context.read<DaftarBelanjaModel>().toggle(i),
            ),
            title: Text(
              '${t.namaBarang} (${t.jumlah})',
              style: t.sudahDibeli
                  ? const TextStyle(
                decoration: TextDecoration.lineThrough,
              )
                  : null,
            ),
            subtitle: Text(t.kategori),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<DaftarBelanjaModel>().hapus(i);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPage(),
            ),
          );

          if (hasil == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Barang Ditambahkan'),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarang = TextEditingController();
  final _jumlah = TextEditingController();

  String? _kategori;

  @override
  void dispose() {
    _namaBarang.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final namaBarang = _namaBarang.text.trim();
    final jumlah = int.parse(_jumlah.text);

    context.read<DaftarBelanjaModel>().tambah(
      namaBarang,
      jumlah,
      _kategori!,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaBarang,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlah,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final jumlah = int.tryParse(value ?? '');

                  if (jumlah == null || jumlah <= 0) {
                    return 'Jumlah harus lebih dari 0!';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Makanan',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: 'Minuman',
                    child: Text('Minuman'),
                  ),
                  DropdownMenuItem(
                    value: 'Kebutuhan Rumah',
                    child: Text('Kebutuhan Rumah'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _kategori = value);
                },
                validator: (value) {
                  return value == null ? 'Pilih kategori!' : null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}