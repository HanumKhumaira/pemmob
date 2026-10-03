import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Praktikum 1',
        home: Scaffold(
          appBar: AppBar(backgroundColor: Color(0xFFEFA7BE),
              title: const Text('Kartu Pengenalan')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.account_circle,
                  size: 100,
                  color: Color(0xFFEFA7BE)
              ),
              SizedBox(height: 18),
              Text('Khumaira',
                  style: TextStyle(fontSize: 28)
              ),
              Text('NIM: 20240801099',
                  style: TextStyle(fontSize: 21)
              ),
              Text('Jurusan : Teknik Informatika',
                  style: TextStyle(fontSize: 21)
              ),
              Text('Hobi: Membaca dan Mendengarkan Musik',
                style: (TextStyle(fontSize: 20)
                )
              )
                ],
              ),
            ),
          ),
        );
    }
}
