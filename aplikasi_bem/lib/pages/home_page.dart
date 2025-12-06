import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Variabel Master (Menyimpan SEMUA lagu dari server)
  List<dynamic> allSongs = [];
  
  // 2. Variabel Filter (Yang ditampilkan di layar)
  List<dynamic> filteredSongs = [];
  
  bool isLoading = true;
  
  // GANTI IP INI SESUAI IP ANDA
  final String apiUrl = "http://10.0.2.2:8000/api/songs";

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  // Fungsi ambil data dari Server
  Future<void> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          // Simpan ke Master Data
          allSongs = jsonData['data'];
          
          // Awalnya, data yang ditampilkan = semua data
          filteredSongs = allSongs; 
          isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Gagal koneksi: $e')),
        );
      }
    }
  }

  // 3. FUNGSI PENCARIAN (Logic Utama)
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // Jika kolom cari kosong, tampilkan semua lagu
      results = allSongs;
    } else {
      // Filter berdasarkan JUDUL atau NOMOR
      results = allSongs.where((song) {
        final titleLower = song['title'].toString().toLowerCase();
        final numberString = song['number'].toString();
        final searchLower = enteredKeyword.toLowerCase();

        return titleLower.contains(searchLower) || numberString.contains(searchLower);
      }).toList();
    }

    // Update tampilan
    setState(() {
      filteredSongs = results;
    });
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
        elevation: 0, 
      ),
      body: Column(
        children: [
          // 4. KOLOM PENCARIAN (SEARCH BAR)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo, // Background header agar menyatu dengan AppBar
            child: TextField(
              onChanged: (value) => _runFilter(value), // Panggil fungsi filter saat mengetik
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Cari Judul atau Nomor...",
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),

          // 5. DAFTAR LAGU (LISTVIEW)
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredSongs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 60, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              "Lagu tidak ditemukan",
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        // PENTING: Gunakan 'filteredSongs', bukan 'allSongs'
                        itemCount: filteredSongs.length, 
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              // Logic Navigasi tetap sama, jadi file tetap bisa dibuka
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongDetailPage(song: song),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
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
                                          Text(
                                            song['category_name'] ?? 'Tanpa Kategori',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
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
          ),
        ],
      ),
    );
  }
}