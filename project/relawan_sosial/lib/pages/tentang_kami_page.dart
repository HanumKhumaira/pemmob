
import 'package:flutter/material.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kami'),
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '01 / TENTANG ORGANISASI',
            style: TextStyle(
              color: Color(0xFFB54725),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Relawan Sosial',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bersama bergerak untuk membantu masyarakat '
                'yang membutuhkan melalui kegiatan sosial '
                'dan kemanusiaan.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF102D20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MISI KAMI',
                  style: TextStyle(
                    color: Color(0xFFDCE9DC),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Menghubungkan relawan dengan kegiatan sosial '
                      'serta mendukung koordinasi informasi '
                      'antara relawan, Korlap, dan Admin Posko.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'APA YANG KAMI LAKUKAN',
            style: TextStyle(
              color: Color(0xFFB54725),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.volunteer_activism_outlined),
            title: Text('Informasi Kegiatan Sosial'),
            subtitle: Text(
              'Menyediakan informasi kegiatan yang membutuhkan relawan.',
            ),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.assignment_outlined),
            title: Text('Pendaftaran Relawan'),
            subtitle: Text(
              'Memudahkan masyarakat mendaftar sebagai relawan.',
            ),
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.groups_outlined),
            title: Text('Koordinasi Lapangan'),
            subtitle: Text(
              'Mendukung penyampaian perubahan kondisi lapangan '
                  'kepada Admin Posko.',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'BERSAMA, KITA BISA BERGERAK LEBIH CEPAT.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102D20),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
