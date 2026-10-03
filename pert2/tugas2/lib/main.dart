import 'package:flutter/material.dart';

class Kontak {
  final String nama;
  final String nomor_telp;
  final String email;

  const Kontak (this.nama, this.nomor_telp, this.email);
}
const daftarKontak = [
  Kontak('Hanny', '089516782788', 'hannyhafsah@gmail.com'),
  Kontak('Aira', '089636389650', 'hhhhumairaawisno@gmail.com'),
  Kontak('Birthgiver', '089508480025', 'mymom@gmail.com'),
  Kontak('Bapak', '089508172699', 'mypa@gmail.com'),
  Kontak('Qiya', '081346829983', 'hannahaqiya@gmail.com'),
  Kontak('Galuh', '081383340095', 'galuhekthayohana@gmail.com'),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kontak')),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final item = daftarKontak[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Color(0xFFEFA7BE),
                borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: CircleAvatar(
                child: Text (item.nama[0].toUpperCase(),
                ),
              ),
              title: Text(item.nama),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(kontak: item)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Kontak kontak;

  const DetailPage({super.key, required this.kontak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kontak.nama)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.lightBlueAccent,),
            const SizedBox(height: 16),
            Text(kontak.nama, style: const TextStyle(fontSize: 24)),
            Text(kontak.nomor_telp, style: const TextStyle(fontSize: 15)),
            Text(kontak.email, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}


