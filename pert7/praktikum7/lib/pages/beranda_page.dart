import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late Future<List<Kegiatan>> _future;

  @override
  void initState() {
    super.initState();
    _future = _ambilData();
    versiData.addListener(_muatUlang);
  }

  @override
  void dispose() {
    versiData.removeListener(_muatUlang);
    super.dispose();
  }

  Future<List<Kegiatan>> _ambilData() {
    final sekarang = DateTime.now();

    final tanggal =
        '${sekarang.year.toString().padLeft(4, '0')}-'
        '${sekarang.month.toString().padLeft(2, '0')}-'
        '${sekarang.day.toString().padLeft(2, '0')}';

    return DbHelper.pada(tanggal);
  }

  void _muatUlang() {
    setState(() {
      _future = _ambilData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Ini'),
      ),
      body: FutureBuilder<List<Kegiatan>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Belum ada kegiatan hari ini'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final kegiatan = data[index];

              return ListTile(
                leading: Checkbox(
                  value: kegiatan.selesai,
                  onChanged: (nilai) async {
                    if (nilai == null) return;

                    await DbHelper.ubah(
                      Kegiatan(
                        id: kegiatan.id,
                        judul: kegiatan.judul,
                        tanggal: kegiatan.tanggal,
                        selesai: nilai,
                        tipe: kegiatan.tipe,
                        nominal: kegiatan.nominal,
                        kategori: kegiatan.kategori,
                      ),
                    );
                  },
                ),
                title: Text(kegiatan.judul),
                subtitle: Text(kegiatan.tipe.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final konfirmasi = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Kegiatan'),
                        content: const Text(
                          'Yakin ingin menghapus kegiatan ini?',
                        ),
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

                    if (konfirmasi == true) {
                      await DbHelper.hapus(kegiatan.id!);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}