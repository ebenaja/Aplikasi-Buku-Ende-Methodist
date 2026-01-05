import 'package:flutter/material.dart';

class SongDetailPage extends StatefulWidget {
  final Map<String, dynamic> song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  // Ukuran Font Default
  double _lyricFontSize = 18.0;
  double _noteFontSize = 16.0;

  // --- LOGIC DETEKSI MARKDOWN ---
  
  // 1. Cek apakah baris ini Gambar?
  bool _isImage(String line) {
    return line.contains("![") && line.contains("](") && line.contains(")");
  }

  // 2. Ambil path gambar dari syntax markdown
  String _extractImagePath(String line) {
    final RegExp imgExp = RegExp(r'!\[.*?\]\((.*?)\)');
    final match = imgExp.firstMatch(line);
    return match?.group(1)?.trim() ?? "";
  }

  // 3. Cek apakah baris ini Not Angka? (Angka, Titik, Garis Miring)
  bool _isMusicalNote(String line) {
    final RegExp notePattern = RegExp(r'^[\d\s\./]+$');
    if (line.contains('/') && line.contains('.')) return true;
    return notePattern.hasMatch(line.trim());
  }

  // 4. Cek apakah baris ini Header Bagian? (Huruf Besar Semua & Pendek)
  bool _isHeader(String line) {
    if (line.trim().isEmpty) return false;
    if (line.contains('=')) return true; // Nada dasar (a=1, 3/2)
    if (line.contains('No.')) return true; // Referensi nomor lain
    // Judul bagian seperti "ENDE PUJI PUJIAN"
    if (line == line.toUpperCase() && line.length < 40 && !RegExp(r'\d').hasMatch(line)) return true;
    return false;
  }

  // --- FITUR ZOOM (SLIDER) ---
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
              padding: const EdgeInsets.all(25),
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
                          min: 14.0,
                          max: 34.0,
                          activeColor: const Color(0xFF0D1B2A),
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (value) {
                            setModalState(() {});
                            setState(() {
                              _lyricFontSize = value;
                              _noteFontSize = value - 2;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 30, color: Colors.black),
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    final Color primaryNavy = const Color(0xFF0D1B2A);
    final Color accentGold = const Color(0xFFD4AF37);
    final Color bgPaper = const Color(0xFFFDFBF7);

    // Pecah lirik menjadi baris per baris
    final List<String> lines = widget.song['lyrics'].toString().split('\n');

    return Scaffold(
      backgroundColor: bgPaper,
      appBar: AppBar(
        title: const Text(
          "Buku Ende Methodist",
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: _showTextSettings,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        physics: const BouncingScrollPhysics(),
        itemCount: lines.length + 1, // +1 untuk Header
        itemBuilder: (context, index) {
          
          // ===========================================
          // BAGIAN A: HEADER (JUDUL & INFO) - Index 0
          // ===========================================
          if (index == 0) {
            return Column(
              children: [
                const SizedBox(height: 10),
                // Badge Nomor (Emas)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentGold.withOpacity(0.5)),
                  ),
                  child: Text(
                    "No. ${widget.song['number']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                      fontFamily: 'Serif',
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),

                // Judul Lagu
                Text(
                  widget.song['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Serif',
                    color: primaryNavy,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 15),

                // Info Nada Dasar & Kategori
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    if (widget.song['key_note'] != null)
                      _buildBadge(widget.song['key_note'], Icons.music_note, Colors.grey[800]!),
                    if (widget.song['category'] != null)
                      _buildBadge(widget.song['category'], Icons.category_outlined, Colors.grey[800]!),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: Divider(
                    color: accentGold.withOpacity(0.3), 
                    thickness: 1, 
                  ),
                ),
              ],
            );
          }

          // ===========================================
          // BAGIAN B: ISI KONTEN (Lirik/Gambar/Not)
          // ===========================================
          String cleanLine = lines[index - 1].trimRight();
          
          // 1. Hapus Baris Kosong
          if (cleanLine.isEmpty) return const SizedBox(height: 12);

          // 2. HAPUS NOMOR GANDA
          // Jika isi baris == Nomor Lagu, sembunyikan.
          if (cleanLine.trim() == widget.song['number'].toString()) {
            return const SizedBox.shrink(); 
          }

          // 3. LOGIC GAMBAR (Local Assets Only)
          if (_isImage(cleanLine)) {
            final String imagePath = _extractImagePath(cleanLine);
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  cacheWidth: 1000, // Optimasi Memori HP
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            );
          }

          // 4. LOGIC NOT ANGKA (Tetap Tengah)
          else if (_isMusicalNote(cleanLine)) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: Text(
                cleanLine,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Courier', // Wajib Monospace
                  fontSize: _noteFontSize,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }

          // 5. LOGIC HEADER BAGIAN (Misal: ENDE PUJI PUJIAN)
          else if (_isHeader(cleanLine)) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                cleanLine,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ),
              ),
            );
          }

          // 6. LOGIC LIRIK BIASA (Rata Kiri)
          else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                cleanLine,
                textAlign: TextAlign.left, // RATA KIRI
                style: TextStyle(
                  fontSize: _lyricFontSize,
                  fontFamily: 'Serif',
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Widget Helper Badge
  Widget _buildBadge(String text, IconData icon, Color color) {
    return Chip(
      label: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      avatar: Icon(icon, size: 14, color: color),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade300),
      visualDensity: VisualDensity.compact,
    );
  }
}