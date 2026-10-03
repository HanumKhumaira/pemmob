import 'package:flutter/material.dart';

class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(this.nama, this.harga, this.deskripsi);
}

  String formatRupiah(int harga){
  return harga.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
      );
  }

const daftarMenu = [
  Makanan('Nasi Goreng', 15000, 'Nasi Goreng dengan Aroma harum dan Rasa yang Khas'),
  Makanan('Mie Ayam', 12000, 'Mie Ayam Khas Banyumas yang WUENAK PWOL!'),
  Makanan('Es Teh', 4000, 'Es Teh Menyegarkan'),
  Makanan('Ayam Bakar', 20000, 'Ayam Bakar dengan Bumbu Khas dan So Smokyyy'),
  Makanan('Ayam Bakar Madu', 18000, 'Ayam Bakar Lezat dengan Bumbu Madu yang Manis:3'),
  Makanan('Aneka Jus', 15000, 'Aneka Jus Sehat dan Menyegarkan'),
  Makanan('Bakso', 16000, 'Bakso Daging yang Menggugah Selera'),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Menu')),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Color(0xFFEFA7BE), borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(item.nama),
              subtitle: Text('Rp ${formatRupiah(item.harga)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(makanan: item)),
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
  final Makanan makanan;

  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80),
            const SizedBox(height: 16),
            Text(makanan.nama, style: const TextStyle(fontSize: 24)),
            Text('Rp ${formatRupiah(makanan.harga)}'),
            Text(makanan.deskripsi, style: const TextStyle(fontSize: 15)),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(Icons.person, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hanum Hawa Khumaira Awisno',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('20240801099'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
