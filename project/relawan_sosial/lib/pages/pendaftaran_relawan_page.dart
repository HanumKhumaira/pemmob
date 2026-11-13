
import 'package:flutter/material.dart';
import 'kontak_kesiapan_page.dart';

class PendaftaranRelawanPage extends StatefulWidget {
  final String namaKegiatan;

  const PendaftaranRelawanPage({
    super.key,
    required this.namaKegiatan,
  });

  @override
  State<PendaftaranRelawanPage> createState() =>
      _PendaftaranRelawanPageState();
}

class _PendaftaranRelawanPageState
    extends State<PendaftaranRelawanPage> {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();

  String? jenisKelamin;
  DateTime? tanggalLahir;

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> pilihTanggalLahir() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahir = tanggal;
      });
    }
  }

  void lanjut() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KontakKesiapanPage(
          namaKegiatan: widget.namaKegiatan,
          namaLengkap: namaController.text.trim(),
          jenisKelamin: jenisKelamin!,
          tanggalLahir: tanggalLahir!,
          alamat: alamatController.text.trim(),
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
              'LANGKAH 01 / 03',
              style: TextStyle(
                color: Color(0xFFB54725),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data Diri',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama lengkap wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: jenisKelamin,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  jenisKelamin = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Jenis kelamin wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FormField<DateTime>(
              validator: (_) {
                if (tanggalLahir == null) {
                  return 'Tanggal lahir wajib dipilih';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await pilihTanggalLahir();
                        field.didChange(tanggalLahir);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          border: const OutlineInputBorder(),
                          errorText: field.errorText,
                        ),
                        child: Text(
                          tanggalLahir == null
                              ? 'Pilih tanggal lahir'
                              : '${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: alamatController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Alamat Domisili',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Alamat domisili wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: lanjut,
              child: const Text('Lanjut ke Kontak & Kesiapan'),
            ),
          ],
        ),
      ),
    );
  }
}
