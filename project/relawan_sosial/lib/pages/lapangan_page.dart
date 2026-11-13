
import 'package:flutter/material.dart';
import 'lapor_revisi_page.dart';
import 'cek_laporan_page.dart';

class LapanganPage extends StatelessWidget {
  const LapanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '01 / OPERASI LAPANGAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Operasi Lapangan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Laporkan perubahan kondisi dan pantau tindak lanjut '
              'Admin Posko melalui fitur operasional lapangan.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF102D20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '01 / LAPOR REVISI',
                style: TextStyle(
                  color: Color(0xFFDCE9DC),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Lapor Revisi Lapangan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Laporkan perubahan kebutuhan relawan, '
                    'kondisi lokasi, atau kendala operasional.',
                style: TextStyle(
                  color: Color(0xFFDCE9DC),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFAF7EF),
                    foregroundColor: const Color(0xFF102D20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LaporRevisiPage(),
                      ),
                    );
                  },
                  child: const Text('Buka Formulir Laporan'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2EEE5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFD6D1C7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '02 / PELACAKAN',
                style: TextStyle(
                  color: Color(0xFFB54725),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cek Status Laporan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pantau status laporan yang telah dikirim '
                    'kepada Admin Posko.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CekLaporanPage(),
                      ),
                    );
                  },
                  child: const Text('Periksa Tindak Lanjut'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
