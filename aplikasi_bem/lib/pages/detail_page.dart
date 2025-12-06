import 'package:flutter/material.dart';

class SongDetailPage extends StatefulWidget {
  final Map<String, dynamic> song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  // --- STATE UKURAN FONT ---
  // Default kita buat 16 (Standar), user bisa ubah nanti
  double _lyricFontSize = 16.0; 
  double _noteFontSize = 14.0;

  // --- LOGIC DETEKSI BARIS ---
  bool _isMusicalNote(String line) {
    final RegExp notePattern = RegExp(r'^[\d\s\./]+$'); 
    if (line.contains('/') && line.contains('.')) return true;
    return notePattern.hasMatch(line.trim());
  }

  bool _isHeader(String line) {
    if (line.trim().isEmpty) return false;
    if (line.contains('=')) return true;
    if (line.contains('No.')) return true; 
    if (line == line.toUpperCase() && line.length < 40) return true;
    return false;
  }

  // --- FUNGSI MUNCULKAN PENGATURAN ZOOM ---
  void _showTextSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ukuran Teks",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.text_fields, size: 18, color: Colors.grey),
                      Expanded(
                        child: Slider(
                          value: _lyricFontSize,
                          min: 12.0, // Ukuran terkecil
                          max: 30.0, // Ukuran terbesar (Zoom in)
                          activeColor: Colors.indigo,
                          inactiveColor: Colors.indigo.withOpacity(0.2),
                          onChanged: (value) {
                            // Update slider di modal
                            setModalState(() {}); 
                            
                            // Update tampilan halaman belakang
                            setState(() {
                              _lyricFontSize = value;
                              _noteFontSize = value - 2; // Not angka selalu lebih kecil dikit
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 28, color: Colors.black),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Ukuran: ${_lyricFontSize.toInt()}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Konstanta Warna
    final Color primaryNavy = const Color(0xFF0D1B2A); 
    final Color accentGold = const Color(0xFFD4AF37);
    final Color paperColor = const Color(0xFFFDFBF7);

    final List<String> lines = widget.song['lyrics'].toString().split('\n');

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        title: const Text("Buku Ende Methodist", style: TextStyle(fontFamily: 'Serif')),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // TOMBOL ZOOM (Icon Aa)
          IconButton(
            icon: const Icon(Icons.text_increase_rounded), 
            tooltip: "Atur Ukuran Teks",
            onPressed: _showTextSettings, // Panggil fungsi slider
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // HEADER (Nomor & Judul) - Ukuran tetap agar proporsional
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: accentGold.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "No. ${widget.song['number']}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentGold,
                      fontFamily: 'Serif',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.song['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22, // Judul jangan terlalu besar
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Serif',
                      color: primaryNavy,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            // INFO CHIPS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.song['key_note'] != null)
                  _buildBadge(widget.song['key_note'], Icons.music_note, primaryNavy),
                if (widget.song['category_name'] != null) ...[
                  const SizedBox(width: 10),
                  _buildBadge(widget.song['category_name'], Icons.category_outlined, Colors.grey[800]!),
                ]
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: accentGold.withOpacity(0.4), thickness: 1, indent: 40, endIndent: 40),
            ),

            // ISI LIRIK (Ukuran Font Dinamis dari Variabel State)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: lines.map((line) {
                String cleanLine = line.trimRight(); 
                if (cleanLine.isEmpty) return const SizedBox(height: 10); 

                // A. NOT ANGKA
                if (_isMusicalNote(cleanLine)) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      color: primaryNavy.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: _noteFontSize, // DINAMIS
                        fontWeight: FontWeight.bold,
                        color: primaryNavy,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                } 
                // B. HEADER BAGIAN
                else if (_isHeader(cleanLine)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _lyricFontSize - 2, // Lebih kecil dari lirik
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }
                // C. LIRIK BIASA
                else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Text(
                      cleanLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _lyricFontSize, // DINAMIS (Zoom effect)
                        fontFamily: 'Serif', 
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}