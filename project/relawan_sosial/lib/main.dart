
import 'package:flutter/material.dart';
import 'pages/beranda_page.dart';
import 'pages/kegiatan_page.dart';
import 'pages/cek_status_page.dart';
import 'pages/lapangan_page.dart';

void main() {
  runApp(const RelawanSosialApp());
}

class RelawanSosialApp extends StatelessWidget {
  const RelawanSosialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relawan Sosial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF7EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF102D20),
          primary: const Color(0xFF102D20),
          surface: const Color(0xFFFAF7EF),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Beranda',
    'Kegiatan',
    'Cek Status Pendaftaran',
    'Lapangan',
  ];

  void navigateToPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7EF),
        surfaceTintColor: Colors.transparent,
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          BerandaPage(
            onNavigate: navigateToPage,
          ),
          const KegiatanPage(),
          const CekStatusPage(),
          const LapanganPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: const Color(0xFFFAF7EF),
        indicatorColor: const Color(0xFFDCE9DC),
        onDestinationSelected: navigateToPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Kegiatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Lapangan',
          ),
        ],
      ),
    );
  }
}