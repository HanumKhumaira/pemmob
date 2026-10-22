**Nama:** Hanum Hawa Khumaira Awisno  
**NIM:** 20240801099  

# Modul 6 — Galeri Wisata Indonesia pada Flutter
## 1. Tujuan Praktikum

Praktikum Modul 6 bertujuan mempelajari pembuatan aplikasi Flutter yang memiliki navigasi, animasi, pengaturan tema, dan interaksi pengguna. Materi diterapkan pada aplikasi Galeri Wisata Indonesia yang menampilkan berbagai destinasi wisata.

Tujuan praktikum:
- Memahami navigasi halaman menggunakan named route.
- Menggunakan `IndexedStack` untuk navigasi tab.
- Mengirim data antarhalaman menggunakan `arguments`.
- Membuat transisi gambar menggunakan `Hero`.
- Mengenal animasi implisit dan eksplisit.
- Mengatur tema terang, gelap, dan warna aplikasi.
- Mengimplementasikan fitur favorit menggunakan `SharedPreferences`.

## 2. Navigasi Menggunakan Named Route

Named route digunakan untuk mengatur perpindahan halaman berdasarkan nama rute. Pada aplikasi ini, rute `/detail` digunakan untuk membuka halaman detail wisata.

Contoh membuka halaman detail:

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: wisata,
);
```

Keterangan:
- `'/detail'`: nama rute halaman detail.
- `arguments`: mengirim objek wisata yang dipilih.
- `wisata`: data destinasi yang akan ditampilkan pada halaman detail.

**Penerapan:** Pengguna dapat memilih destinasi wisata dari halaman utama untuk melihat informasi lebih lanjut.

## 3. Menggunakan IndexedStack

`IndexedStack` digunakan untuk menampilkan halaman berdasarkan indeks yang aktif. Pada aplikasi ini, widget tersebut digunakan untuk mengatur tab Beranda, Favorit, dan Pengaturan.

```dart
IndexedStack(
  index: tabAktif,
  children: [
    halamanBeranda(),
    halamanFavorit(),
    halamanPengaturan(),
  ],
);
```

Keterangan:
- `index`: menentukan halaman yang sedang ditampilkan.
- `children`: kumpulan halaman yang tersedia.

**Manfaat:** `IndexedStack` membantu mempertahankan state halaman tab ketika pengguna berpindah tab.

## 4. Hero Animation

Widget `Hero` digunakan untuk membuat transisi visual pada elemen yang sama ketika berpindah halaman.

Contoh penerapan:

```dart
Hero(
  tag: 'wisata-${wisata.id}',
  child: Image.network(
    wisata.gambar,
    fit: BoxFit.cover,
  ),
);
```

Hal yang perlu diperhatikan:
- Widget `Hero` pada halaman asal dan tujuan harus menggunakan tag yang sama.
- Tag sebaiknya unik untuk setiap destinasi.
- Transisi membuat perpindahan gambar dari daftar wisata ke halaman detail terlihat lebih halus.

**Penerapan:** Gambar destinasi wisata memiliki transisi ketika pengguna membuka halaman detail.

## 5. Animasi pada Flutter

Flutter menyediakan animasi implisit dan eksplisit.

| Jenis | Karakteristik | Widget |
|---|---|---|
| Implisit | Properti dianimasikan otomatis ketika nilainya berubah. | `AnimatedContainer` |
| Eksplisit | Animasi dikontrol menggunakan controller. | `AnimationController`, `AnimatedBuilder` |

`AnimatedContainer` dapat menganimasikan perubahan properti seperti warna, ukuran, dan dekorasi berdasarkan nilai yang diberikan.

Sementara itu, `AnimationController` digunakan untuk mengontrol jalannya animasi, sedangkan `AnimatedBuilder` membangun ulang bagian widget yang bergantung pada nilai animasi.

Aplikasi juga menggunakan `Transform.rotate` untuk menerapkan rotasi berdasarkan nilai animasi.

**Kesimpulan:** Animasi membuat antarmuka aplikasi lebih interaktif dan memberikan transisi visual pada elemen tertentu.

## 6. Mengatur Tema Aplikasi

`ThemeData` digunakan untuk mengatur tampilan aplikasi, termasuk warna dan gaya komponen. Aplikasi ini menyediakan tema terang dan gelap.

Contoh konfigurasi:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: warnaTema,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: warnaTema,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ),
);
```

Keterangan:
- `theme`: konfigurasi tema terang.
- `darkTheme`: konfigurasi tema gelap.
- `seedColor`: warna dasar untuk membentuk skema warna.
- `useMaterial3`: mengaktifkan Material Design 3.

Pengguna dapat mengganti mode tema dan memilih warna tema melalui halaman Pengaturan.

## 7. Implementasi Fitur Favorit

Fitur favorit digunakan untuk menandai destinasi wisata yang disukai pengguna. Status favorit dikelola menggunakan `Set` berisi ID wisata.

Contoh pemeriksaan status favorit:

```dart
favorit.contains(wisata.id)
```

Contoh pengelolaan status:

```dart
setState(() {
  if (favorit.contains(wisata.id)) {
    favorit.remove(wisata.id);
  } else {
    favorit.add(wisata.id);
  }
});
```

Keterangan:
- `favorit`: kumpulan ID wisata yang ditandai.
- `contains()`: memeriksa apakah wisata sudah menjadi favorit.
- `add()`: menambahkan ID wisata ke favorit.
- `remove()`: menghapus ID wisata dari favorit.
- `setState()`: memperbarui tampilan ketika state berubah.

**Penerapan:** Halaman Favorit menampilkan destinasi yang telah dipilih pengguna.

## 8. Menyimpan Data dengan SharedPreferences

`SharedPreferences` digunakan untuk menyimpan data sederhana dalam format key-value. Pada aplikasi ini, SharedPreferences digunakan untuk menyimpan daftar favorit, preferensi tema, dan warna tema.

Contoh menyimpan daftar favorit:

```dart
final prefs = await SharedPreferences.getInstance();

await prefs.setStringList(
  'favoritWisata',
  favorit.map((id) => id.toString()).toList(),
);
```

Untuk membaca daftar favorit:

```dart
final prefs = await SharedPreferences.getInstance();

final data = prefs.getStringList('favoritWisata') ?? [];
```

Data ID yang dibaca kemudian dikonversi kembali menjadi kumpulan ID bertipe integer.

**Manfaat:** Preferensi pengguna dapat tetap tersedia ketika aplikasi ditutup dan dibuka kembali, selama data aplikasi tidak dihapus.

## 9. Menjalankan Aplikasi

Buka terminal pada direktori proyek yang ingin dijalankan.

**Project praktikum:**

```bash
cd pert6/praktikum6
flutter pub get
flutter run
```

**Project tugas:**

```bash
cd pert6/tugas6
flutter pub get
flutter run
```

Keterangan:
- `flutter pub get` mengunduh package yang dibutuhkan aplikasi.
- `flutter run` menjalankan aplikasi pada emulator atau perangkat yang terhubung.

Pastikan dependency `shared_preferences` sudah tercantum di `pubspec.yaml`. Jika aplikasi menggunakan gambar dari internet, pastikan perangkat memiliki koneksi internet.

## 10. Kesimpulan

Pada Modul 6, mahasiswa mempelajari navigasi menggunakan named route, pengelolaan tab dengan `IndexedStack`, pengiriman data antarhalaman, animasi `Hero`, animasi implisit dan eksplisit, serta pengaturan tema Flutter.

Selain itu, aplikasi Galeri Wisata Indonesia menerapkan fitur favorit dan penyimpanan preferensi menggunakan `SharedPreferences`. Materi tersebut membantu membangun aplikasi yang lebih interaktif, terstruktur, dan dapat mempertahankan pilihan pengguna.
