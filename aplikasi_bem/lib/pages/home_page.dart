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
  // --- KONSTANTA WARNA (Agar senada dengan Landing Page) ---
  final Color primaryNavy = const Color(0xFF0D1B2A); // Biru Dongker Gelap
  final Color accentGold = const Color(0xFFD4AF37);  // Emas Mewah
  final Color bgPaper = const Color(0xFFF8F9FA);     // Putih Tulang (Kertas)

  // 1. Variabel Data
  List<dynamic> allSongs = [];
  List<dynamic> filteredSongs = [];
  bool isLoading = true;
  
  // GANTI IP INI SESUAI KONFIGURASI ANDA
  final String apiUrl = "http://10.0.2.2:8000/api/songs";

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          allSongs = jsonData['data'];
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

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSongs;
    } else {
      results = allSongs.where((song) {
        final titleLower = song['title'].toString().toLowerCase();
        final numberString = song['number'].toString();
        final searchLower = enteredKeyword.toLowerCase();
        return titleLower.contains(searchLower) || numberString.contains(searchLower);
      }).toList();
    }
    setState(() {
      filteredSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPaper, // Latar belakang tidak putih polos, tapi agak abu terang
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 0,
        toolbarHeight: 0, // Sembunyikan AppBar standar, kita buat custom header
      ),
      body: Column(
        children: [
          // ==========================================
          // 1. CUSTOM HEADER (Melengkung & Mewah)
          // ==========================================
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 10),
            decoration: BoxDecoration(
              color: primaryNavy,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Aplikasi Kecil
                Row(
                  children: [
                    Icon(Icons.menu_book, color: accentGold, size: 28),
                    const SizedBox(width: 10),
                    const Text(
                      "Buku Ende Methodist",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif', // Font Buku
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Search Bar Modern
                TextField(
                  onChanged: (value) => _runFilter(value),
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Cari Nomor atau Judul Lagu...",
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: primaryNavy),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. DAFTAR LAGU
          // ==========================================
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryNavy))
                : filteredSongs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_music_outlined, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            Text(
                              "Lagu tidak ditemukan",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        // Bouncing scroll effect (Android 12+ / iOS style)
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredSongs.length,
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongDetailPage(song: song),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // NOMOR LAGU (Aksen Emas)
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: primaryNavy.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: accentGold.withOpacity(0.5),
                                            width: 1.5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${song['number']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Serif',
                                            color: primaryNavy,
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 16),
                                      
                                      // JUDUL & KATEGORI
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: primaryNavy,
                                                fontFamily: 'Serif', // Judul pakai Serif biar klasik
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(Icons.label_outline, 
                                                  size: 14, color: Colors.grey.shade500),
                                                const SizedBox(width: 4),
                                                Text(
                                                  song['category_name'] ?? '//',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // ARROW ICON
                                      Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
                                    ],
                                  ),
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