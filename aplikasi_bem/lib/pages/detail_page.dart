import 'package:flutter/material.dart';

class SongDetailPage extends StatelessWidget {
  final Map<String, dynamic> song;

  const SongDetailPage({super.key, required this.song});

  // FUNGSI PINTAR: Menebak apakah baris ini adalah Not Angka?
  bool _isMusicalNote(String line) {
    // Jika baris mengandung banyak angka, titik, atau garis miring
    // Regex: Mencari baris yang didominasi angka 0-7, spasi, titik, garis miring
    final RegExp notePattern = RegExp(r'^[\d\s\./]+$'); 
    
    // Atau kasus khusus yang mengandung birama (misal: 5 . / 1 1)
    if (line.contains('/') && line.contains('.')) return true;
    
    return notePattern.hasMatch(line.trim());
  }

  // FUNGSI PINTAR: Menebak apakah ini Metadata/Judul bagian (huruf kapital semua/pendek)
  bool _isHeader(String line) {
    // Contoh: "ENDE PUJI PUJIAN" atau "a = 1, 3/2"
    if (line.trim().isEmpty) return false;
    if (line.contains('=')) return true; // Nada dasar
    if (line.contains('No.')) return true; // Referensi nomor
    if (line == line.toUpperCase() && line.length < 40) return true; // Judul Kategori
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Kita pecah lirik panjang menjadi baris-baris (Array of String)
    final List<String> lines = song['lyrics'].toString().split('\n');

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Warna kertas agak krem (Warm)
      appBar: AppBar(
        title: Text("Buku Ende No. ${song['number']}"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: (){}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // --- HEADER JUDUL ---
            Text(
              song['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 15),

            // --- INFO CHIPS (Nada & Kategori) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (song['key_note'] != null)
                  _buildInfoBadge("Nada: ${song['key_note']}"),
                if (song['category_name'] != null) ...[
                  const SizedBox(width: 8),
                  _buildInfoBadge(song['category_name']),
                ]
              ],
            ),
            
            const Divider(height: 40, thickness: 1.5, color: Colors.black12),

            // --- LOOPING SETIAP BARIS LIRIK ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Biar not angka menuhin layar
              children: lines.map((line) {
                // Hapus spasi berlebih di awal/akhir
                String cleanLine = line.trimRight(); 
                if (cleanLine.isEmpty) return const SizedBox(height: 10); // Jarak antar bait

                // LOGIC GANTI FONT
                if (_isMusicalNote(cleanLine)) {
                  // --- GAYA NOT ANGKA (UI UTAMA YG DIPERBAIKI) ---
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    // Background tipis biar not angka menonjol
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.03), 
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center, // Not angka biasanya di tengah
                      style: const TextStyle(
                        fontFamily: 'Courier', // MONOSPACE (Kunci agar rapi)
                        fontSize: 16, 
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo, // Warna biru biar beda sama lirik
                        letterSpacing: 0.5, // Sedikit renggang
                      ),
                    ),
                  );
                } 
                else if (_isHeader(cleanLine)) {
                  // --- GAYA INFO TAMBAHAN (Spt: ENDE PUJI PUJIAN) ---
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                else {
                  // --- GAYA LIRIK (Seperti Buku) ---
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 2.0),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18, // Font besar
                        fontFamily: 'Serif', // Font kaki (mirip Times New Roman)
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}