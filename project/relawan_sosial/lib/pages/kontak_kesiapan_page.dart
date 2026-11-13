
import 'package:flutter/material.dart';
import 'konfirmasi_pendaftaran_page.dart';

class KontakKesiapanPage extends StatefulWidget {
  final String namaKegiatan;
  final String namaLengkap;
  final String jenisKelamin;
  final DateTime tanggalLahir;
  final String alamat;

  const KontakKesiapanPage({
    super.key,
    required this.namaKegiatan,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.alamat,
  });

  @override
  State<KontakKesiapanPage> createState() =>
      _KontakKesiapanPageState();
}

class _KontakKesiapanPageState extends State<KontakKesiapanPage> {
  final formKey = GlobalKey<FormState>();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();

  final List<String> daftarKeahlian = [
    'Medis',
    'Dapur Umum',
    'Logistik',
    'Dokumentasi',
    'Pendataan',
    'Kebersihan',
  ];

  final Set<String> keahlianDipilih = {};
  String? ketersediaan;

  @override
  void dispose() {
    whatsappController.dispose();
    emailController.dispose();
    super.dispose();
  }


  void lanjut() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (keahlianDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu keahlian.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KonfirmasiPendaftaranPage(
          namaKegiatan: widget.namaKegiatan,
          namaLengkap: widget.namaLengkap,
          jenisKelamin: widget.jenisKelamin,
          tanggalLahir: widget.tanggalLahir,
          alamat: widget.alamat,
          whatsapp: whatsappController.text.trim(),
          email: emailController.text.trim(),
          keahlian: keahlianDipilih.toList(),
          ketersediaan: ketersediaan!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'LANGKAH 02 / 03',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kontak & Kesiapan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
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
                  return 'Masukkan nomor WhatsApp yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nama@email.com',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Email wajib diisi';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(email)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Keahlian Relawan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: daftarKeahlian.map((keahlian) {
                return FilterChip(
                  label: Text(keahlian),
                  selected: keahlianDipilih.contains(keahlian),
                  onSelected: (dipilih) {
                    setState(() {
                      if (dipilih) {
                        keahlianDipilih.add(keahlian);
                      } else {
                        keahlianDipilih.remove(keahlian);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              initialValue: ketersediaan,
              decoration: const InputDecoration(
                labelText: 'Ketersediaan Waktu',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pagi',
                  child: Text('Pagi'),
                ),
                DropdownMenuItem(
                  value: 'Siang',
                  child: Text('Siang'),
                ),
                DropdownMenuItem(
                  value: 'Sore',
                  child: Text('Sore'),
                ),
                DropdownMenuItem(
                  value: 'Sepanjang Hari',
                  child: Text('Sepanjang Hari'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  ketersediaan = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Pilih ketersediaan waktu';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: lanjut,
              child: const Text('Lanjut ke Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }
}
