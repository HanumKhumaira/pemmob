NAMA: Hanum Hawa Khumaira Awisno
NIM: 20240801099

# Modul 4 — Flutter Fundamental: Future, API, dan FutureBuilder

## 1. Yang Dipelajari

Pada praktikum ini, gue belajar membuat aplikasi Flutter yang mengambil data dari REST API, mengolah data JSON menjadi objek Dart, lalu menampilkannya ke UI.

Materi utama:
- REST API dan HTTP GET
- JSON dan `jsonDecode()`
- Model data dan `fromJson()`
- `Future` dan proses asynchronous
- `FutureBuilder`
- Loading, error, dan retry
- Navigasi antarhalaman menggunakan `Navigator`
- Mengambil data berdasarkan ID

## 2. REST API

REST API memungkinkan aplikasi mengambil data dari server melalui HTTP.

Pada praktikum ini, API yang digunakan adalah JSONPlaceholder.

### Endpoint daftar postingan

```text
https://jsonplaceholder.typicode.com/posts
```

Endpoint tersebut mengembalikan daftar postingan dalam format JSON.

### Endpoint komentar

```text
https://jsonplaceholder.typicode.com/posts/{id}/comments
```

Contoh untuk mengambil komentar postingan dengan ID 1:

```text
https://jsonplaceholder.typicode.com/posts/1/comments
```

Perbedaan keduanya:
- `/posts` mengambil daftar postingan.
- `/posts/1/comments` mengambil komentar milik postingan dengan ID 1.

## 3. HTTP GET dan Mengambil Data

Paket `http` digunakan untuk mengirim permintaan HTTP ke server.

```dart
final uri = Uri.parse(
  'https://jsonplaceholder.typicode.com/posts',
);

final response = await http.get(uri);
```

Penjelasan:
- `Uri.parse()` mengubah URL menjadi objek URI.
- `http.get()` meminta data dari server.
- `await` menunggu proses asynchronous selesai.
- `response` berisi respons dari server.

Sebelum memproses data, periksa status respons:

```dart
if (response.statusCode != 200) {
  throw Exception('Gagal memuat data');
}
```

Status `200` menunjukkan permintaan berhasil. Jika status berbeda, aplikasi dapat menangani kondisi tersebut sebagai error.

## 4. JSON dan jsonDecode()

Data dari API biasanya diterima sebagai teks JSON. Agar bisa diolah di Dart, respons tersebut perlu diubah menjadi objek Dart.

```dart
final List<dynamic> data = jsonDecode(response.body);
```

Penjelasan:
- `response.body` adalah isi respons dalam bentuk teks.
- `jsonDecode()` mengubah teks JSON menjadi struktur data Dart.
- `List<dynamic>` digunakan karena respons daftar postingan berbentuk list.

Setelah itu, data dapat diubah menjadi objek model:

```dart
return data
    .map((item) => Post.fromJson(item as Map<String, dynamic>))
    .toList();
```

Kode tersebut mengubah setiap item JSON menjadi objek `Post`.

## 5. Model Data dan fromJson()

Model digunakan untuk merepresentasikan data API dalam bentuk objek Dart.

### Model Post

```dart
class Post {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
```

Field pada model:
- `id`: ID postingan.
- `title`: judul postingan.
- `body`: isi postingan.

### Model Komentar

Model `Komentar` memiliki:
- `id`: ID komentar.
- `name`: nama atau judul komentar.
- `body`: isi komentar.

`fromJson()` berfungsi memetakan key JSON menjadi field pada objek Dart.

Contohnya, `json['title']` mengambil nilai `title` dari data JSON.

**Intinya:** model membantu membuat data API lebih terstruktur dan mudah digunakan di widget Flutter.

## 6. Future dan async/await

`Future` merepresentasikan hasil operasi yang tersedia pada waktu mendatang, misalnya setelah aplikasi selesai meminta data dari server.

Contoh deklarasi fungsi:

```dart
Future<List<Post>> ambilPost() async {
  // Mengambil data dari API dan mengubahnya menjadi List<Post>.
}
```

Penjelasan:
- `Future<List<Post>>` berarti fungsi menghasilkan daftar objek `Post` secara asynchronous.
- `async` menandai fungsi asynchronous.
- `await` menunggu operasi asynchronous selesai tanpa memblokir UI secara langsung.

Karena pengambilan data membutuhkan waktu, UI tidak boleh menganggap data langsung tersedia.

## 7. FutureBuilder

`FutureBuilder` digunakan untuk membangun UI berdasarkan kondisi dari sebuah `Future`.

Contoh pola yang digunakan:

```dart
FutureBuilder<List<Post>>(
  future: _future,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return const Text('Terjadi kesalahan');
    }

    final posts = snapshot.data ?? [];

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.body),
        );
      },
    );
  },
)
```

Hal penting:
- `future`: operasi asynchronous yang dipantau.
- `builder`: fungsi yang membangun UI.
- `snapshot.connectionState`: status proses Future.
- `snapshot.hasError`: memeriksa apakah operasi gagal.
- `snapshot.data`: mengambil hasil operasi yang berhasil.

### Tiga kondisi utama

| Kondisi | Pemeriksaan | Tampilan |
|---|---|---|
| Loading | `ConnectionState.waiting` | `CircularProgressIndicator` |
| Error | `snapshot.hasError` | Pesan error dan tombol retry |
| Berhasil | Data tersedia | Daftar postingan atau komentar |

## 8. Mengapa Future Disimpan dalam Variabel?

Pada halaman daftar, Future disimpan di variabel state:

```dart
late Future<List<Post>> _future;

@override
void initState() {
  super.initState();
  _future = ambilPost();
}
```

`initState()` dijalankan ketika state widget pertama kali dibuat.

Dengan menyimpan Future, `FutureBuilder` memantau operasi yang sama selama widget dibangun ulang, alih-alih memulai permintaan API baru pada setiap pemanggilan `build()`.

## 9. Menangani Error dan Retry

Jika permintaan API gagal, aplikasi perlu memberikan informasi kepada pengguna dan menyediakan cara untuk mencoba kembali.

```dart
void _muatUlang() {
  setState(() {
    _future = ambilPost();
  });
}
```

Penjelasan:
- `ambilPost()` membuat permintaan data baru.
- `setState()` memperbarui state widget.
- `FutureBuilder` menerima Future baru dan memantau proses pengambilan data kembali.

Pola yang sama diterapkan pada pengambilan komentar di halaman detail.

### Cara menguji error

1. Buka aplikasi dan pastikan daftar postingan tampil.
2. Putuskan koneksi internet emulator.
3. Tekan refresh atau jalankan permintaan data ketika offline.
4. Pastikan pesan error dan tombol Coba lagi tampil.
5. Pulihkan koneksi internet.
6. Tekan Coba lagi dan pastikan data berhasil dimuat.

Error seperti `SocketException` dapat terjadi ketika perangkat tidak bisa menjangkau server, misalnya karena koneksi internet terputus.

## 10. Navigasi ke Halaman Detail

Untuk membuka detail postingan, aplikasi menggunakan `Navigator.push()`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailPostPage(post: post),
  ),
);
```

Objek `post` dikirim ke halaman detail melalui constructor:

```dart
class DetailPostPage extends StatefulWidget {
  final Post post;

  const DetailPostPage({
    super.key,
    required this.post,
  });
}
```

Dengan cara ini, halaman detail langsung menerima data postingan yang dipilih tanpa perlu mengambil ulang seluruh daftar postingan.

## 11. Mengambil Komentar Berdasarkan ID

Fungsi komentar menerima parameter `postId`:

```dart
Future<List<Komentar>> ambilKomentar(int postId) async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts/$postId/comments',
  );

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Gagal memuat komentar');
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map(
        (item) => Komentar.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}
```

Perhatikan penggunaan `$postId` pada URL. ID tersebut menentukan komentar milik postingan yang sedang dibuka.

Pengambilan komentar dilakukan secara terpisah dari pengambilan daftar postingan, sehingga error komentar dapat ditangani secara independen di halaman detail.

## 12. Refresh Data

Aplikasi menyediakan dua cara untuk memuat ulang daftar postingan:
- Tombol refresh pada AppBar.
- Gestur tarik ke bawah menggunakan `RefreshIndicator`.

Keduanya memanggil fungsi yang membuat Future baru untuk mengambil data dari API.

Refresh berguna ketika pengguna ingin meminta data terbaru atau mencoba kembali setelah terjadi kegagalan koneksi.

## 13. Alur Kerja Aplikasi

1. Aplikasi dijalankan.
2. `PostPage` memanggil `ambilPost()`.
3. `FutureBuilder` menampilkan loading.
4. Respons API diubah dari JSON menjadi objek `Post`.
5. Daftar postingan ditampilkan.
6. Pengguna memilih salah satu postingan.
7. `Navigator.push()` membuka `DetailPostPage`.
8. Detail isi postingan ditampilkan.
9. `ambilKomentar(post.id)` mengambil komentar.
10. `FutureBuilder` menampilkan loading, error, atau daftar komentar sesuai kondisi.

## 14. Ringkasan Materi

Hal terpenting yang perlu diingat dari praktikum ini:

- **REST API:** sumber data dari server.
- **HTTP GET:** meminta data dari API.
- **JSON:** format pertukaran data.
- **Model dan `fromJson()`:** mengubah JSON menjadi objek Dart.
- **Future:** merepresentasikan hasil operasi asynchronous.
- **async/await:** membantu menulis operasi asynchronous dengan alur yang mudah dibaca.
- **FutureBuilder:** menampilkan UI berdasarkan status Future.
- **Navigator:** berpindah halaman dan mengirim data.
- **setState():** memperbarui UI setelah state berubah.
- **Error handling dan retry:** menangani kegagalan dan mengulangi permintaan.
- **RefreshIndicator:** memuat ulang data melalui gestur tarik ke bawah.
