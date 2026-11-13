
import 'package:flutter/material.dart';
import 'pendaftaran_relawan_page.dart';

class DetailKegiatanPage extends StatelessWidget {
  final String judul;
  final String lokasi;
  final String tanggal;
  final String kebutuhan;
  final String status;

  const DetailKegiatanPage({
    super.key,
    required this.judul,
    required this.lokasi,
    required this.tanggal,
    required this.kebutuhan,
    required this.status,
  });

  Widget informasi(String label, String isi) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EEE5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFB54725),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isi,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202820),
            ),
          ),
        ],
      ),
    );
  }

  Widget judulBagian(String nomor, String judul) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nomor,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFFB54725),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          judul,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202820),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool pendaftaranDibuka =
        status.toUpperCase() == 'DIBUKA' ||
            status.toUpperCase() == 'KUOTA TERBATAS';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kegiatan'),
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(minHeight: 145),
            decoration: BoxDecoration(
              color: const Color(0xFF102D20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFDCE9DC),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          informasi('Lokasi', lokasi),
          informasi('Tanggal', tanggal),
          informasi('Kebutuhan Relawan', kebutuhan),
          const SizedBox(height: 24),
          judulBagian('01 / RINGKASAN', 'Ringkasan Kegiatan'),
          const SizedBox(height: 12),
          const Text(
            'Kegiatan ini bertujuan membantu masyarakat yang '
                'membutuhkan dukungan relawan dalam pelaksanaan '
                'kegiatan sosial dan penanganan bencana.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF454A43),
            ),
          ),
          const SizedBox(height: 28),
          judulBagian('02 / PERSYARATAN', 'Persyaratan Relawan'),
          const SizedBox(height: 12),
          const Text(
            '• Bersedia mengikuti arahan Komandan Lapangan\n'
                '• Mengikuti jadwal kegiatan yang ditentukan\n'
                '• Menjaga keselamatan dan kerja sama tim\n'
                '• Bersedia menjalankan tugas sesuai kebutuhan',
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Color(0xFF454A43),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 8, 18, 12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: pendaftaranDibuka
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PendaftaranRelawanPage(
                        namaKegiatan: judul,
                      ),
                ),
              );
            }
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF102D20),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFB9B9B2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              pendaftaranDibuka
                  ? 'Daftar sebagai Relawan'
                  : 'Pendaftaran Ditutup',
            ),
          ),
        ),
      ),
    );
  }
}
