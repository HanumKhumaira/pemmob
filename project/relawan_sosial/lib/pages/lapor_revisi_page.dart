
import 'package:flutter/material.dart';

class LaporRevisiPage extends StatefulWidget {
  const LaporRevisiPage({super.key});

  @override
  State<LaporRevisiPage> createState() => _LaporRevisiPageState();
}

class _LaporRevisiPageState extends State<LaporRevisiPage> {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final whatsappController = TextEditingController();
  final uraianController = TextEditingController();

  String? kegiatanDipilih;
  String? kategoriDipilih;

  final List<String> daftarKegiatan = [
    'Posko Bantuan Banjir Bekasi',
    'Aksi Relawan Pascagempa Cianjur',
    'Dapur Umum Korban Banjir',
  ];

  final List<String> daftarKategori = [
    'Perubahan Kebutuhan Relawan',
    'Kendala Logistik',
    'Perubahan Kondisi Lokasi',
    'Kendala Operasional',
    'Informasi Lainnya',
  ];

  @override
  void dispose() {
    namaController.dispose();
    whatsappController.dispose();
    uraianController.dispose();
    super.dispose();
  }

  void kirimLaporan() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data laporan valid. Pengiriman ke Laravel belum diaktifkan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Revisi Lapangan'),
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              '01 / INFORMASI KEGIATAN',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lapor Kondisi Lapangan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Laporkan perubahan kondisi, kebutuhan, atau kendala '
                  'operasional yang perlu ditindaklanjuti Admin Posko.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              initialValue: kegiatanDipilih,
              decoration: const InputDecoration(
                labelText: 'Pilih Kegiatan',
                border: OutlineInputBorder(),
              ),
              items: daftarKegiatan.map((kegiatan) {
                return DropdownMenuItem(
                  value: kegiatan,
                  child: Text(
                    kegiatan,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  kegiatanDipilih = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Kegiatan wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            const Text(
              '02 / IDENTITAS KORLAP',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Komandan Lapangan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama Korlap wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor WhatsApp',
                hintText: '08xxxxxxxxxx',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final nomor = value?.trim() ?? '';

                if (nomor.isEmpty) {
                  return 'Nomor WhatsApp wajib diisi';
                }

                if (!RegExp(r'^08[0-9]{8,11}$').hasMatch(nomor)) {
                  return 'Nomor WhatsApp tidak valid';
                }

                return null;
              },
            ),
            const SizedBox(height: 28),
            const Text(
              '03 / PERUBAHAN KONDISI',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: kategoriDipilih,
              decoration: const InputDecoration(
                labelText: 'Kategori Perubahan',
                border: OutlineInputBorder(),
              ),
              items: daftarKategori.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(
                    kategori,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  kategoriDipilih = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Kategori perubahan wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: uraianController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Uraian Situasi Lapangan',
                hintText: 'Jelaskan kondisi atau perubahan terbaru',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Uraian situasi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: kirimLaporan,
                child: const Text('Kirim Laporan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
