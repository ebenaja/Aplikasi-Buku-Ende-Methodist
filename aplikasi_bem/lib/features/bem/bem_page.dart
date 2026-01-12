import 'package:flutter/material.dart';
import '../../database_helper.dart';
import 'bem_detail_page.dart';

class BukuEndePage extends StatefulWidget {
  const BukuEndePage({super.key});

  @override
  State<BukuEndePage> createState() => _BukuEndePageState();
}

class _BukuEndePageState extends State<BukuEndePage> {
  // --- PALET WARNA ---
  final Color primaryNavy = const Color(0xFF0D1B2A);
  final Color secondaryNavy = const Color(0xFF1B263B);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color bgPaper = const Color(0xFFF8F9FA);

  List<Map<String, dynamic>> allSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final data = await DatabaseHelper.instance.getAllSongs();
    setState(() {
      allSongs = data;
      isLoading = false;
    });
  }

  Future<void> _runFilter(String keyword) async {
    if (keyword.isEmpty) {
      _loadSongs();
    } else {
      final results = await DatabaseHelper.instance.searchSongs(keyword);
      setState(() {
        allSongs = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPaper,
      // Hapus AppBar standar agar bisa custom header
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryNavy,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ==========================================
          // 1. HEADER (BACK BUTTON & SEARCH)
          // ==========================================
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryNavy, secondaryNavy],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryNavy.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BARIS JUDUL & TOMBOL BACK
                Row(
                  children: [
                    // Tombol Kembali
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new, color: accentGold, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    
                    const SizedBox(width: 15),
                    
                    // Ikon Buku
                    Icon(Icons.library_music, color: accentGold, size: 28),
                    
                    const SizedBox(width: 10),
                    
                    // Judul Halaman
                    Expanded(
                      child: Text(
                        "Buku Ende",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // KOLOM PENCARIAN
                TextField(
                  onChanged: (value) => _runFilter(value),
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Cari Nomor atau Judul Lagu...",
                    hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: primaryNavy),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. LIST LAGU
          // ==========================================
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryNavy))
                : allSongs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_music_outlined,
                                size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            Text(
                              "Lagu tidak ditemukan",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        physics: const BouncingScrollPhysics(),
                        itemCount: allSongs.length,
                        itemBuilder: (context, index) {
                          final song = allSongs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SongDetailPage(song: song),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Row(
                                    children: [
                                      // KOTAK NOMOR EMAS PUDAR
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: accentGold.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${song['number']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Serif',
                                            color: primaryNavy,
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(width: 15),
                                      
                                      // JUDUL LAGU
                                      Expanded(
                                        child: Text(
                                          song['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: primaryNavy,
                                            fontFamily: 'Serif',
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                      
                                      // PANAH KANAN
                                      Icon(Icons.chevron_right_rounded,
                                          size: 24, color: Colors.grey.shade400),
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
