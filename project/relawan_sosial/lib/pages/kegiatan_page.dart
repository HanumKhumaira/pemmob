
import 'package:flutter/material.dart';
import '../widgets/kegiatan_card.dart';
import 'detail_kegiatan_page.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  String kataKunci = '';

  final List<Map<String, String>> daftarKegiatan = [
    {
      'judul': 'Posko Bantuan Banjir Bekasi',
      'lokasi': 'Bekasi, Jawa Barat',
      'tanggal': '25 Oktober 2026',
      'kebutuhan': '18 relawan dibutuhkan',
      'status': 'DIBUKA',
    },
    {
      'judul': 'Aksi Relawan Pascagempa Cianjur',
      'lokasi': 'Cianjur, Jawa Barat',
      'tanggal': '28 Oktober 2026',
      'kebutuhan': '7 relawan dibutuhkan',
      'status': 'KUOTA TERBATAS',
    },
    {
      'judul': 'Dapur Umum Korban Banjir',
      'lokasi': 'Tangerang, Banten',
      'tanggal': '30 Oktober 2026',
      'kebutuhan': '12 relawan dibutuhkan',
      'status': 'DIBUKA',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final hasilPencarian = daftarKegiatan.where((kegiatan) {
      final judul = kegiatan['judul']!.toLowerCase();
      final lokasi = kegiatan['lokasi']!.toLowerCase();
      final pencarian = kataKunci.trim().toLowerCase();

      return judul.contains(pencarian) || lokasi.contains(pencarian);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '01 / DAFTAR KEGIATAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Temukan Kegiatan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102D20),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cari kegiatan sosial atau penanganan bencana yang tersedia.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666B63),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari kegiatan atau lokasi',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            setState(() {
              kataKunci = value;
            });
          },
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            Chip(
              label: const Text('BENCANA SOSIAL'),
              backgroundColor: const Color(0xFFE9E5DA),
              side: BorderSide.none,
              labelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Chip(
              label: const Text('DIBUKA'),
              backgroundColor: const Color(0xFFDCE9DC),
              side: BorderSide.none,
              labelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Chip(
              label: const Text('SOSIAL'),
              backgroundColor: const Color(0xFFE9E5DA),
              side: BorderSide.none,
              labelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (hasilPencarian.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('Kegiatan tidak ditemukan.'),
            ),
          )
        else
          ...hasilPencarian.map((kegiatan) {
            return KegiatanCard(
              judul: kegiatan['judul']!,
              lokasi: kegiatan['lokasi']!,
              tanggal: kegiatan['tanggal']!,
              kebutuhan: kegiatan['kebutuhan']!,
              status: kegiatan['status']!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKegiatanPage(
                      judul: kegiatan['judul']!,
                      lokasi: kegiatan['lokasi']!,
                      tanggal: kegiatan['tanggal']!,
                      kebutuhan: kegiatan['kebutuhan']!,
                      status: kegiatan['status']!,
                    ),
                  ),
                );
              },
            );
          }),
      ],
    );
  }
}
