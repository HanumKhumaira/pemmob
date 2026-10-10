NAMA: Hanum Hawa Khumaira Awisno
NIM: 20240801099

# Modul 5 — Aplikasi Pencatatan Pengeluaran — Flutter dan SQLite

## 1. Yang Dipelajari

Pada praktikum ini, gue belajar membuat aplikasi Flutter untuk mencatat dan mengelola pengeluaran menggunakan database lokal. Aplikasi dilengkapi fitur tambah, edit, hapus, pencarian, pengurutan data, serta pengaturan tema.

Materi utama:

- Flutter dan widget Material Design
- SQLite menggunakan paket `sqflite`
- SharedPreferences untuk menyimpan preferensi
- Operasi CRUD (Create, Read, Update, Delete)
- Menampilkan daftar data menggunakan widget Flutter
- Pencarian data menggunakan query SQL
- Pengurutan data berdasarkan tanggal
- Validasi input formulir
- Navigasi antarhalaman menggunakan Navigator
- Pengelolaan state menggunakan `setState()`

## 2. SQLite dan Penyimpanan Data

SQLite merupakan database relasional yang dapat digunakan untuk menyimpan data secara lokal pada perangkat.

Pada praktikum ini, SQLite digunakan untuk menyimpan data pengeluaran sehingga data tetap tersedia ketika aplikasi ditutup dan dibuka kembali.

Paket yang digunakan:

```yaml
sqflite:
path:
```

` sqflite ` digunakan untuk mengakses database SQLite, sedangkan `path` membantu menentukan lokasi file database.

## 3. Model Data Pengeluaran

Model digunakan untuk merepresentasikan data pengeluaran dalam bentuk objek Dart.

Model `Pengeluaran` memiliki beberapa field:

- `id`: ID unik pengeluaran.
- `nama`: nama pengeluaran.
- `jumlah`: nominal pengeluaran.
- `kategori`: kategori pengeluaran.
- `tanggal`: tanggal pengeluaran.

Model ini membantu data menjadi lebih terstruktur dan mudah digunakan pada halaman utama maupun formulir.

## 4. Database Helper dan Operasi CRUD

Database helper bertugas mengelola interaksi antara aplikasi dan database SQLite.

Operasi utama yang digunakan:

- **Create:** menambahkan data pengeluaran.
- **Read:** mengambil dan menampilkan data pengeluaran.
- **Update:** memperbarui data yang sudah tersimpan.
- **Delete:** menghapus data pengeluaran.

Operasi tersebut memungkinkan pengguna mengelola catatan pengeluaran secara langsung melalui aplikasi.

## 5. Membuat dan Membuka Database

Database dibuat ketika aplikasi pertama kali membutuhkan penyimpanan data.

Callback `onCreate` digunakan untuk membuat tabel ketika database baru dibuat.

Contoh pembuatan tabel:

```dart
await db.execute('''
  CREATE TABLE pengeluaran (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    jumlah INTEGER NOT NULL,
    kategori TEXT NOT NULL,
    tanggal TEXT NOT NULL
  )
''');
```

Penjelasan:

- `id` merupakan primary key yang bertambah secara otomatis.
- `nama` menyimpan nama pengeluaran.
- `jumlah` menyimpan nominal pengeluaran.
- `kategori` menyimpan kategori pengeluaran.
- `tanggal` menyimpan tanggal pengeluaran.

Callback `onUpgrade` digunakan untuk melakukan perubahan struktur database ketika versi database dinaikkan.

## 6. Menambahkan dan Mengedit Data

Formulir digunakan untuk memasukkan atau memperbarui informasi pengeluaran.

Data yang dimasukkan meliputi:

- Nama pengeluaran.
- Jumlah pengeluaran.
- Kategori.
- Tanggal.

Saat pengguna menyimpan formulir, aplikasi melakukan validasi input terlebih dahulu. Jika data valid, aplikasi menjalankan operasi insert atau update pada SQLite.

Validasi diperlukan agar data yang disimpan sesuai dengan format yang diharapkan, misalnya nama tidak kosong dan jumlah pengeluaran harus berupa angka lebih dari nol.

## 7. Menampilkan Data Pengeluaran

Data yang tersimpan di SQLite diambil kembali untuk ditampilkan pada halaman utama.

Halaman utama menampilkan daftar pengeluaran beserta informasi yang relevan, seperti nama, jumlah, kategori, dan tanggal.

Ketika data ditambahkan, diedit, atau dihapus, tampilan perlu diperbarui agar sesuai dengan kondisi database terbaru.

Contoh pembaruan tampilan:

```dart
setState(() {
  _muat();
});
```

`setState()` memberi tahu Flutter bahwa state widget berubah sehingga UI perlu dibangun ulang.

## 8. Menghitung Total Pengeluaran

Aplikasi menampilkan total dari seluruh nominal pengeluaran yang tersimpan.

Perhitungan dapat dilakukan menggunakan fungsi agregasi SQL, yaitu `SUM()`.

Contoh query:

```sql
SELECT SUM(jumlah) FROM pengeluaran;
```

Query tersebut menjumlahkan seluruh nilai pada kolom `jumlah`.

Hasilnya digunakan untuk menampilkan total pengeluaran pada halaman utama.

## 9. Pencarian Data

Fitur pencarian digunakan untuk menemukan pengeluaran berdasarkan nama.

Contoh query menggunakan parameter:

```dart
where: 'nama LIKE ?',
whereArgs: ['%$pencarian%'],
```

Penjelasan:

- `LIKE` digunakan untuk mencari teks yang sesuai dengan pola.
- Tanda `%` memungkinkan pencarian teks yang mengandung kata tertentu.
- `whereArgs` digunakan untuk mengirim nilai parameter secara terpisah dari perintah SQL.

Penggunaan parameter membantu mencegah SQL injection dan mengurangi risiko kesalahan ketika memproses input pengguna.

## 10. Pengurutan Data

Aplikasi menyediakan fitur untuk mengurutkan data pengeluaran berdasarkan tanggal terbaru atau terlama.

Pengurutan membantu pengguna menemukan catatan berdasarkan urutan waktu.

Urutan data dapat diatur melalui query database dengan klausa `ORDER BY`.

- `DESC`: mengurutkan dari nilai terbesar ke terkecil, atau terbaru ke terlama jika kolom tanggal disimpan dalam format yang sesuai.
- `ASC`: mengurutkan dari nilai terkecil ke terbesar, atau terlama ke terbaru jika format tanggal mendukung pengurutan tersebut.

Preferensi urutan dapat disimpan menggunakan SharedPreferences agar pilihan pengguna tetap tersimpan.

## 11. SharedPreferences

SharedPreferences digunakan untuk menyimpan data preferensi sederhana dalam bentuk key-value.

Pada praktikum ini, SharedPreferences digunakan untuk menyimpan:

- Preferensi tema gelap atau terang dengan key `tema_gelap`.
- Preferensi urutan data dengan key `urutan_terbaru`.

Contoh penyimpanan preferensi:

```dart
final prefs = await SharedPreferences.getInstance();

await prefs.setBool('tema_gelap', true);
```

Penjelasan:

- `getInstance()` mengambil instance SharedPreferences.
- `setBool()` menyimpan nilai bertipe boolean.
- Key digunakan untuk mengidentifikasi preferensi yang disimpan.

SharedPreferences cocok untuk pengaturan sederhana, tetapi tidak ditujukan untuk menyimpan ratusan catatan pengeluaran. Data utama tetap disimpan menggunakan SQLite.

## 12. Navigasi dan Memuat Ulang Data

Navigasi digunakan untuk berpindah dari halaman utama ke halaman formulir pengeluaran.

Setelah formulir selesai menyimpan atau memperbarui data, halaman utama perlu memuat ulang daftar pengeluaran.

Salah satu pola yang digunakan adalah mengembalikan nilai dari halaman formulir melalui `Navigator.pop()`.

```dart
Navigator.pop(context, true);
```

Halaman utama dapat memeriksa nilai tersebut. Jika hasilnya `true`, aplikasi memuat ulang data agar perubahan segera terlihat.

Pola ini memastikan tampilan daftar tetap sesuai dengan data yang tersimpan di database.

## 13. Alur Kerja Aplikasi

1. Aplikasi dijalankan.
2. Preferensi tema dan pengurutan dibaca dari SharedPreferences.
3. Database SQLite dibuka.
4. Data pengeluaran diambil dari database.
5. Daftar pengeluaran dan total ditampilkan.
6. Pengguna dapat mencari atau mengurutkan data.
7. Pengguna dapat menambahkan, mengedit, atau menghapus pengeluaran.
8. Data disimpan atau diubah melalui database helper.
9. Halaman utama memuat ulang data setelah perubahan.
10. Preferensi pengguna disimpan agar dapat digunakan kembali.

## 14. Ringkasan Materi

Hal terpenting yang perlu diingat dari praktikum ini:

- **SQLite:** database lokal untuk menyimpan data pengeluaran.
- **Model data:** merepresentasikan data sebagai objek Dart.
- **CRUD:** operasi menambah, membaca, memperbarui, dan menghapus data.
- **Database helper:** mengelola akses dan query database.
- **SQL `SUM()`:** menghitung total pengeluaran.
- **SQL `LIKE`:** mencari data berdasarkan pola teks.
- **`whereArgs`:** mengirim parameter query secara terpisah.
- **`ORDER BY`:** mengurutkan data berdasarkan kolom tertentu.
- **SharedPreferences:** menyimpan preferensi sederhana.
- **Validasi form:** memastikan input pengguna sesuai ketentuan.
- **`setState()`:** memperbarui UI setelah perubahan state.
- **Navigator:** berpindah halaman dan mengembalikan hasil dari halaman formulir.
