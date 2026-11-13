
import 'package:flutter/material.dart';

class KonfirmasiPendaftaranPage extends StatefulWidget {
  final String namaKegiatan;
  final String namaLengkap;
  final String jenisKelamin;
  final DateTime tanggalLahir;
  final String alamat;
  final String whatsapp;
  final String email;
  final List<String> keahlian;
  final String ketersediaan;

  const KonfirmasiPendaftaranPage({
    super.key,
    required this.namaKegiatan,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.alamat,
    required this.whatsapp,
    required this.email,
    required this.keahlian,
    required this.ketersediaan,
  });

  @override
  State<KonfirmasiPendaftaranPage> createState() =>
      _KonfirmasiPendaftaranPageState();
}

class _KonfirmasiPendaftaranPageState
    extends State<KonfirmasiPendaftaranPage> {
  final formKey = GlobalKey<FormState>();
  final motivasiController = TextEditingController();

  @override
  void dispose() {
    motivasiController.dispose();
    super.dispose();
  }

  void kirimPendaftaran() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data sudah valid. Pengiriman ke Laravel belum diaktifkan.',
        ),
      ),
    );
  }

  Widget barisInformasi(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFB54725),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tanggal =
        '${widget.tanggalLahir.day}/${widget.tanggalLahir.month}/${widget.tanggalLahir.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Relawan'),
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.namaKegiatan,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'LANGKAH 03 / 03',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Motivasi & Konfirmasi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: motivasiController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Motivasi Menjadi Relawan',
                hintText: 'Ceritakan alasan ingin bergabung',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Motivasi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'RINGKASAN PENDAFTARAN',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
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
                  barisInformasi(
                    'Kegiatan',
                    widget.namaKegiatan,
                  ),
                  barisInformasi(
                    'Nama Lengkap',
                    widget.namaLengkap,
                  ),
                  barisInformasi(
                    'Jenis Kelamin',
                    widget.jenisKelamin,
                  ),
                  barisInformasi(
                    'Tanggal Lahir',
                    tanggal,
                  ),
                  barisInformasi(
                    'Alamat',
                    widget.alamat,
                  ),
                  barisInformasi(
                    'WhatsApp',
                    widget.whatsapp,
                  ),
                  barisInformasi(
                    'Email',
                    widget.email,
                  ),
                  barisInformasi(
                    'Keahlian',
                    widget.keahlian.join(', '),
                  ),
                  barisInformasi(
                    'Ketersediaan',
                    widget.ketersediaan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: kirimPendaftaran,
              child: const Text('Kirim Pendaftaran'),
            ),
          ],
        ),
      ),
    );
  }
}
