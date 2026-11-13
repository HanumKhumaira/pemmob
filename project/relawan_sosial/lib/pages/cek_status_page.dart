
import 'package:flutter/material.dart';

class CekStatusPage extends StatefulWidget {
  const CekStatusPage({super.key});

  @override
  State<CekStatusPage> createState() => _CekStatusPageState();
}

class _CekStatusPageState extends State<CekStatusPage> {
  final formKey = GlobalKey<FormState>();
  final whatsappController = TextEditingController();
  final kodeController = TextEditingController();

  String? statusPendaftaran;
  bool sudahDicari = false;

  @override
  void dispose() {
    whatsappController.dispose();
    kodeController.dispose();
    super.dispose();
  }

  void periksaStatus() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      sudahDicari = true;

      final kode = kodeController.text.trim().toUpperCase();

      if (kode == 'RLS-001') {
        statusPendaftaran = 'MENUNGGU VERIFIKASI';
      } else if (kode == 'RLS-002') {
        statusPendaftaran = 'DITERIMA';
      } else if (kode == 'RLS-003') {
        statusPendaftaran = 'DITOLAK';
      } else {
        statusPendaftaran = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          '01 / STATUS RELAWAN',
          style: TextStyle(
            color: Color(0xFFB54725),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cek Status Pendaftaran',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan data yang digunakan saat mendaftar.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 24),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor WhatsApp wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Referensi',
                  hintText: 'Contoh: RLS-001',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode referensi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: periksaStatus,
                  child: const Text('Periksa Status'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (sudahDicari)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2EEE5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD6D1C7),
              ),
            ),
            child: statusPendaftaran == null
                ? const Text(
              'Data pendaftaran tidak ditemukan.',
              style: TextStyle(fontSize: 14),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HASIL VERIFIKASI',
                  style: TextStyle(
                    color: Color(0xFFB54725),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusPendaftaran!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusPendaftaran == 'DITERIMA'
                      ? 'Pendaftaran kamu telah disetujui.'
                      : statusPendaftaran == 'DITOLAK'
                      ? 'Pendaftaran kamu belum dapat diterima.'
                      : 'Pendaftaran sedang diperiksa oleh Admin Posko.',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
