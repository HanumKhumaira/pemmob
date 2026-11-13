
import 'package:flutter/material.dart';

class CekLaporanPage extends StatefulWidget {
  const CekLaporanPage({super.key});

  @override
  State<CekLaporanPage> createState() => _CekLaporanPageState();
}

class _CekLaporanPageState extends State<CekLaporanPage> {
  final formKey = GlobalKey<FormState>();
  final whatsappController = TextEditingController();

  String? kegiatanDipilih;
  String? statusLaporan;
  bool sudahDicari = false;

  final List<String> daftarKegiatan = [
    'Posko Bantuan Banjir Bekasi',
    'Aksi Relawan Pascagempa Cianjur',
    'Dapur Umum Korban Banjir',
  ];

  @override
  void dispose() {
    whatsappController.dispose();
    super.dispose();
  }

  void periksaLaporan() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      sudahDicari = true;

      switch (kegiatanDipilih) {
        case 'Posko Bantuan Banjir Bekasi':
          statusLaporan = 'MENUNGGU PEMERIKSAAN';
          break;
        case 'Aksi Relawan Pascagempa Cianjur':
          statusLaporan = 'SEDANG DITINDAKLANJUTI';
          break;
        case 'Dapur Umum Korban Banjir':
          statusLaporan = 'SELESAI DITINDAKLANJUTI';
          break;
        default:
          statusLaporan = null;
      }
    });
  }

  String keteranganStatus() {
    switch (statusLaporan) {
      case 'MENUNGGU PEMERIKSAAN':
        return 'Laporan sedang menunggu pemeriksaan Admin Posko.';
      case 'SEDANG DITINDAKLANJUTI':
        return 'Laporan sedang ditindaklanjuti oleh Admin Posko.';
      case 'SELESAI DITINDAKLANJUTI':
        return 'Tindak lanjut laporan telah diselesaikan.';
      default:
        return 'Laporan tidak ditemukan.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Status Laporan'),
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '02 / PELACAKAN LAPORAN',
            style: TextStyle(
              color: Color(0xFFB54725),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Cek Status Laporan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pilih kegiatan dan masukkan nomor WhatsApp '
                'yang digunakan saat mengirim laporan.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          Form(
            key: formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: kegiatanDipilih,
                  isExpanded: true,
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
                      sudahDicari = false;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih kegiatan terlebih dahulu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: whatsappController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp Korlap',
                    hintText: '08xxxxxxxxxx',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (sudahDicari) {
                      setState(() {
                        sudahDicari = false;
                      });
                    }
                  },
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: periksaLaporan,
                    child: const Text('Periksa Status Laporan'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HASIL SIMULASI',
                    style: TextStyle(
                      color: Color(0xFFB54725),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    statusLaporan ?? 'TIDAK DITEMUKAN',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    keteranganStatus(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Status ini hanya contoh dan belum berasal dari database.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF77736C),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
