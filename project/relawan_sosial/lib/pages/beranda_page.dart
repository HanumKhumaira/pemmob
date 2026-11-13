
import 'package:flutter/material.dart';
import '../widgets/kegiatan_card.dart';
import 'tentang_kami_page.dart';

class BerandaPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const BerandaPage({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'RELAWAN SOSIAL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'RELAWAN SOSIAL\nSIAP BERGERAK!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Temukan kegiatan sosial, bergabung sebagai relawan, '
              'dan pantau proses pendaftaran dengan mudah.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF102D20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.photo_library_outlined,
                color: Color(0xFFFAF7EF),
                size: 22,
              ),
              SizedBox(height: 30),
              Text(
                'DOKUMENTASI LAPANGAN',
                style: TextStyle(
                  color: Color(0xFFFAF7EF),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Posko Banjir Bekasi · 25 Okt 2026',
                style: TextStyle(
                  color: Color(0xFFDCE9DC),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '01 / RELAWAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Untuk Relawan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => onNavigate(1),
          child: const Text('Cari Kegiatan'),
        ),
        OutlinedButton(
          onPressed: () => onNavigate(1),
          child: const Text('Daftar Relawan'),
        ),
        OutlinedButton(
          onPressed: () => onNavigate(2),
          child: const Text('Cek Status Pendaftaran'),
        ),
        const SizedBox(height: 30),
        const Text(
          '02 / KOMANDAN LAPANGAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Operasional Lapangan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => onNavigate(3),
          child: const Text('Buka Fitur Lapangan'),
        ),
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          '03 / UPDATE KEGIATAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Kegiatan Terbaru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        KegiatanCard(
          judul: 'Posko Bantuan Banjir Bekasi',
          lokasi: 'Bekasi, Jawa Barat',
          tanggal: '25 Oktober 2026',
          kebutuhan: '18 relawan dibutuhkan',
          status: 'DIBUKA',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TentangKamiPage(),
              ),
            );
          },
          icon: const Icon(Icons.info_outline),
          label: const Text('Tentang Kami'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
