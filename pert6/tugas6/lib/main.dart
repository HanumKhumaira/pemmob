import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.teal);

const pilihanWarna = [
  Colors.teal,
  Colors.indigo,
  Colors.deepOrange,
  Colors.pink,
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  final warna = prefs.getInt('warnaTema') ?? 0;

  themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  seedColor.value = pilihanWarna[warna.clamp(0, pilihanWarna.length - 1)];

  runApp(const MyApp());
}

class Wisata {
  final int id;
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;

  const Wisata({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
  });
}

const daftarWisata = [
  Wisata(
    id: 1,
    nama: 'Raja Ampat',
    lokasi: 'Papua Barat Daya',
    deskripsi:
    'Raja Ampat terkenal dengan gugusan pulau karst, air laut jernih, dan keanekaragaman hayati bawah laut yang menakjubkan.',
    ikon: Icons.scuba_diving,
  ),
  Wisata(
    id: 2,
    nama: 'Candi Borobudur',
    lokasi: 'Magelang, Jawa Tengah',
    deskripsi:
    'Candi Borobudur merupakan candi Buddha bersejarah dengan relief dan arsitektur yang menjadi daya tarik wisata Indonesia.',
    ikon: Icons.account_balance,
  ),
  Wisata(
    id: 3,
    nama: 'Gunung Bromo',
    lokasi: 'Jawa Timur',
    deskripsi:
    'Gunung Bromo menawarkan pemandangan pegunungan, lautan pasir, dan matahari terbit yang populer di kalangan wisatawan.',
    ikon: Icons.landscape,
  ),
  Wisata(
    id: 4,
    nama: 'Danau Toba',
    lokasi: 'Sumatera Utara',
    deskripsi:
    'Danau Toba merupakan danau vulkanik besar dengan Pulau Samosir dan kekayaan budaya masyarakat Batak.',
    ikon: Icons.water,
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Color>(
          valueListenable: seedColor,
          builder: (context, warna, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Galeri Wisata Indonesia',
              themeMode: mode,
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: warna,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: warna,
                brightness: Brightness.dark,
              ),
              home: const HalamanUtama(),
              onGenerateRoute: (settings) {
                if (settings.name == '/detail') {
                  final wisata = settings.arguments as Wisata;

                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return HalamanDetail(wisata: wisata);
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  );
                }

                return null;
              },
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(
                    body: Center(
                      child: Text('Halaman tidak ditemukan'),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int index = 0;
  Set<int> favorit = {};

  @override
  void initState() {
    super.initState();
    muatFavorit();
  }

  Future<void> muatFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favoritWisata') ?? <String>[];
    final idFavorit = data.map(int.tryParse).whereType<int>().toSet();

    if (!mounted) return;

    setState(() {
      favorit = idFavorit;
    });
  }

  Future<void> simpanFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoritWisata',
      favorit.map((id) => id.toString()).toList(),
    );
  }

  void bukaDetail(Wisata wisata) {
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: wisata,
    );
  }

  Future<void> ubahFavorit(Wisata wisata) async {
    final favoritBaru = Set<int>.from(favorit);

    if (favoritBaru.contains(wisata.id)) {
      favoritBaru.remove(wisata.id);
    } else {
      favoritBaru.add(wisata.id);
    }

    // Simpan snapshot daftar favorit yang baru.
    final prefs = await SharedPreferences.getInstance();
    final berhasil = await prefs.setStringList(
      'favoritWisata',
      favoritBaru.map((id) => id.toString()).toList(),
    );

    if (!mounted) return;

    if (berhasil) {
      setState(() {
        favorit = favoritBaru;
      });
    }
  }

  Widget kartuWisata(Wisata wisata) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => bukaDetail(wisata),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'wisata-${wisata.id}',
              child: Container(
                height: 130,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  wisata.ikon,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            ListTile(
              title: Text(
                wisata.nama,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(wisata.lokasi),
              trailing: IconButton(
                onPressed: () => ubahFavorit(wisata),
                icon: Icon(
                  favorit.contains(wisata.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorit.contains(wisata.id)
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget halamanBeranda() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          'Jelajahi Indonesia',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Temukan destinasi wisata pilihanmu.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        for (final wisata in daftarWisata) kartuWisata(wisata),
      ],
    );
  }

  Widget halamanFavorit() {
    final data = daftarWisata
        .where((wisata) => favorit.contains(wisata.id))
        .toList();

    if (data.isEmpty) {
      return const Center(
        child: Text('Belum ada wisata favorit.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final wisata in data) kartuWisata(wisata),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final halaman = [
      halamanBeranda(),
      halamanFavorit(),
      const HalamanPengaturan(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Wisata Indonesia'),
      ),
      body: IndexedStack(
        index: index,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() => index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class HalamanDetail extends StatelessWidget {
  final Wisata wisata;

  const HalamanDetail({
    super.key,
    required this.wisata,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Wisata'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'wisata-${wisata.id}',
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                wisata.ikon,
                size: 110,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            wisata.nama,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            wisata.lokasi,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            wisata.deskripsi,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class HalamanPengaturan extends StatefulWidget {
  const HalamanPengaturan({super.key});

  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool tampilKartu = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> ubahMode(bool aktif) async {
    themeMode.value = aktif ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', aktif);
  }

  Future<void> ubahWarna(int index) async {
    seedColor.value = pilihanWarna[index];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('warnaTema', index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pengaturan Tampilan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeMode,
          builder: (context, mode, _) {
            return SwitchListTile(
              title: const Text('Mode gelap'),
              subtitle: const Text('Simpan pilihan tema'),
              value: mode == ThemeMode.dark,
              onChanged: ubahMode,
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Warna tema',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            for (int i = 0; i < pilihanWarna.length; i++)
              ValueListenableBuilder<Color>(
                valueListenable: seedColor,
                builder: (context, warna, _) {
                  return GestureDetector(
                    onTap: () => ubahWarna(i),
                    child: CircleAvatar(
                      backgroundColor: pilihanWarna[i],
                      child: warna == pilihanWarna[i]
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Animasi Implisit',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: tampilKartu ? 180 : 110,
            height: tampilKartu ? 100 : 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(tampilKartu ? 12 : 40),
            ),
            child: Icon(
              Icons.photo_library,
              size: 44,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            setState(() => tampilKartu = !tampilKartu);
          },
          child: const Text('Ubah Bentuk'),
        ),
        const SizedBox(height: 24),
        Text(
          'Animasi Eksplisit',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.value * 6.283185307179586,
                child: child,
              );
            },
            child: Icon(
              Icons.explore,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            if (controller.isAnimating) {
              controller.stop();
            } else {
              controller.repeat();
            }
          },
          child: const Text('Mulai / Hentikan Animasi'),
        ),
      ],
    );
  }
}