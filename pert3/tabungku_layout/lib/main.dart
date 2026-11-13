
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// tampilan utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: const TabungKuPage(),
    );
  }
}

// halaman ringkasan tabungan
class TabungKuPage extends StatelessWidget {
  const TabungKuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // judul di bagian atas
      appBar: AppBar(
        title: const Text('Ringkasan Tabungan'),
        backgroundColor: Colors.pink.shade100,
      ),

      // biar halaman bisa discroll
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // kartu buat info tabungan
          Card(
            color: Colors.pink.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tabungan Impian',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Saldo Saat Ini'),
                  const Text(
                    'Rp 2.500.000',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // target tabungan dibikin sejajar
                  const Row(
                    children: [
                      Expanded(
                        child: Text('Target Tabungan'),
                      ),
                      Text(
                        'Rp 5.000.000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // tiga menu utama
          Row(
            children: [
              Expanded(
                child: Column(
                  children: const [
                    Icon(
                      Icons.add_circle,
                      size: 36,
                      color: Colors.pink,
                    ),
                    SizedBox(height: 8),
                    Text('Menabung'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Icon(
                      Icons.remove_circle,
                      size: 36,
                      color: Colors.pink,
                    ),
                    SizedBox(height: 8),
                    Text('Tarik'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Icon(
                      Icons.history,
                      size: 36,
                      color: Colors.pink,
                    ),
                    SizedBox(height: 8),
                    Text('Riwayat'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // judul bagian transaksi
          const Text(
            'Riwayat Transaksi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // transaksi pertama
          const Card(
            child: ListTile(
              leading: Icon(
                Icons.arrow_downward,
                color: Colors.green,
              ),
              title: Text('Setoran Tabungan'),
              subtitle: Text('8 November 2026'),
              trailing: Text('+ Rp 500.000'),
            ),
          ),

          // transaksi kedua
          const Card(
            child: ListTile(
              leading: Icon(
                Icons.arrow_downward,
                color: Colors.green,
              ),
              title: Text('Tabungan Bulanan'),
              subtitle: Text('5 November 2026'),
              trailing: Text('+ Rp 300.000'),
            ),
          ),

          // transaksi ketiga
          const Card(
            child: ListTile(
              leading: Icon(
                Icons.arrow_upward,
                color: Colors.red,
              ),
              title: Text('Penarikan'),
              subtitle: Text('2 November 2026'),
              trailing: Text('- Rp 100.000'),
            ),
          ),
        ],
      ),
    );
  }
}
