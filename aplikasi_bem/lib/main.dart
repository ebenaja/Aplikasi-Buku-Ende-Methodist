import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Buku Ende Methodist',
      theme: ThemeData(
        // Menggunakan warna Indigo (Khas Methodist sering pakai warna gelap/biru/merah)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel state
  List<dynamic> songs = [];
  bool isLoading = true;

  // ---------------------------------------------------------
  // PENTING: GANTI IP INI DENGAN IP LAPTOP ANDA
  // Cara cek di Windows: buka cmd ketik 'ipconfig'
  // Jangan pakai 'localhost' atau '127.0.0.1' untuk Android Emulator/HP Fisik
  // ---------------------------------------------------------
  final String apiUrl = "http://10.0.2.2:8000/api/songs";

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  // Fungsi mengambil data dari API Laravel (PostgreSQL)
  Future<void> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        setState(() {
          // Kita ambil array 'data' dari respon JSON
          songs = jsonData['data']; 
          isLoading = false;
        });
      } else {
        throw Exception('Server merespon tapi gagal: ${response.statusCode}');
      }
    } catch (e) {
      // Jika error (misal server mati / beda wifi)
      print("Error mengambil data: $e");
      setState(() => isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal koneksi ke server: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Coba Lagi',
              textColor: Colors.white,
              onPressed: fetchSongs,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Buku Ende Methodist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              fetchSongs();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : songs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        "Data lagu kosong atau tidak ditemukan.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Nanti disini navigasi ke detail lirik
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Membuka: ${song['title']}")),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Bagian Nomor Lagu
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${song['number']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Bagian Judul dan Kategori
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.category, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          // INI BAGIAN PENTING:
                                          // Mengambil 'category_name' dari hasil JOIN PostgreSQL
                                          song['category_name'] ?? 'Tanpa Kategori',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Menampilkan Nada Dasar jika ada
                                        if (song['key_note'] != null) ...[
                                          Icon(Icons.music_note, size: 14, color: Colors.grey[600]),
                                          const SizedBox(width: 2),
                                          Text(
                                            song['key_note'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}