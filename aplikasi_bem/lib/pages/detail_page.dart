import 'package:flutter/material.dart';

class SongDetailPage extends StatefulWidget {
  final Map<String, dynamic> song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  double _lyricFontSize = 16.0;
  double _noteFontSize = 14.0;

  // LOGIC DETEKSI (Sama seperti sebelumnya)
  bool _isImage(String line) {
    return line.contains("![") && line.contains("](") && line.contains(")");
  }

  String _extractImagePath(String line) {
    final RegExp imgExp = RegExp(r'!\[.*?\]\((.*?)\)');
    final match = imgExp.firstMatch(line);
    return match?.group(1)?.trim() ?? "";
  }

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
                children: [
                  const Text("Ukuran Teks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.text_fields, size: 18, color: Colors.grey),
                      Expanded(
                        child: Slider(
                          value: _lyricFontSize,
                          min: 12.0, max: 30.0,
                          activeColor: const Color(0xFF0D1B2A),
                          onChanged: (value) {
                            setModalState(() {});
                            setState(() {
                              _lyricFontSize = value;
                              _noteFontSize = value - 2;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 28, color: Colors.black),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: _showTextSettings,
          ),
        ],
      ),
      // PERUBAHAN UTAMA DI SINI:
      // Menggunakan ListView.builder agar ringan saat discroll
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        // Jumlah item = Header (1) + Jumlah Baris Lirik
        itemCount: lines.length + 1,
        itemBuilder: (context, index) {
          
          // A. JIKA INDEX 0 -> TAMPILKAN HEADER (Judul, No, Badge)
          if (index == 0) {
            return Column(
              children: [
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentGold, fontFamily: 'Serif'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.song['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Serif', color: primaryNavy, height: 1.2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
              ],
            );
          }

          // B. JIKA INDEX > 0 -> TAMPILKAN ISI LIRIK
          // Kita ambil baris ke (index - 1) karena index 0 dipakai header
          String cleanLine = lines[index - 1].trimRight();
          if (cleanLine.isEmpty) return const SizedBox(height: 10);

          // 1. LOGIC GAMBAR
          if (_isImage(cleanLine)) {
            final String imagePath = _extractImagePath(cleanLine);
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Builder(
                  builder: (context) {
                    if (imagePath.startsWith('http')) {
                      return Image.network(imagePath, fit: BoxFit.contain);
                    } else {
                      // OPTIMASI: Tambahkan cacheWidth agar Flutter tidak memuat resolusi penuh
                      return Image.asset(
                        imagePath, 
                        fit: BoxFit.contain,
                        // Ini kuncinya: Resize gambar ke lebar layar saja (sekitar 800-1000px)
                        // Agar memori HP tidak meledak saat gambar aslinya 4000px
                        cacheWidth: 1000, 
                        errorBuilder: (_,__,___) => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Gambar tidak ditemukan", style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }

          // 2. LOGIC NOT ANGKA
          else if (_isMusicalNote(cleanLine)) {
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
                  fontSize: _noteFontSize,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }

          // 3. LOGIC HEADER BAGIAN
          else if (_isHeader(cleanLine)) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                cleanLine,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _lyricFontSize - 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          // 4. LOGIC LIRIK BIASA
          else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
              child: Text(
                cleanLine,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _lyricFontSize,
                  fontFamily: 'Serif',
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            );
          }
        },
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
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}