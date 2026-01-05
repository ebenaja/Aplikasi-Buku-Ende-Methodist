import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NrmDetailPage extends StatefulWidget {
  final int index; // Halaman saat ini (mulai dari 0)
  final int totalPage; // Total halaman yang tersedia

  const NrmDetailPage({
    super.key,
    required this.index,
    required this.totalPage,
  });

  @override
  State<NrmDetailPage> createState() => _NrmDetailPageState();
}

class _NrmDetailPageState extends State<NrmDetailPage> {
  final TransformationController _controller = TransformationController();

  double _zoomScale = 1.0;
  bool _darkMode = false;
  bool _bookmarked = false;
  late int _currentPage;

  // --- PALET WARNA ---
  final Color primaryNavy = const Color(0xFF0D1B2A);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color bgLight = const Color(0xFFFDFBF7); // Kertas Putih Gading
  final Color bgDark = const Color(0xFF121212); // Hitam Lembut

  @override
  void initState() {
    super.initState();
    _currentPage = widget.index;
    _loadState();
    _saveLastRead();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('nrm_dark') ?? false;
      _bookmarked = prefs.getBool('bookmark_$_currentPage') ?? false;
    });
  }

  Future<void> _saveLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_read_nrm', _currentPage);
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _bookmarked = !_bookmarked);
    prefs.setBool('bookmark_$_currentPage', _bookmarked);
    
    // Feedback Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _bookmarked ? "Halaman ditandai" : "Tanda dihapus",
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: accentGold,
      ),
    );
  }

  // ===== NAVIGASI HALAMAN (Ganti Halaman) =====
  void _changePage(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.totalPage) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => NrmDetailPage(
            index: newIndex,
            totalPage: widget.totalPage,
          ),
          transitionDuration: Duration.zero, // Instan tanpa animasi geser
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  // ===== POPUP ZOOM SETTINGS =====
  void _showZoomSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Container(
              padding: const EdgeInsets.all(25),
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Perbesar Tampilan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.zoom_out, color: Colors.grey),
                      Expanded(
                        child: Slider(
                          value: _zoomScale,
                          min: 1.0,
                          max: 4.0,
                          activeColor: primaryNavy,
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (v) {
                            setModal(() => _zoomScale = v);
                            setState(() {
                              _controller.value = Matrix4.identity()..scale(v);
                            });
                          },
                        ), 
                      ),
                      const Icon(Icons.zoom_in, size: 30, color: Colors.black),
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

  // ===== DIALOG CARI HALAMAN =====
  void _searchPage() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Lompat ke Halaman", style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Masukkan nomor (1 - ${widget.totalPage})",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryNavy, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryNavy),
              onPressed: () {
                final page = int.tryParse(controller.text);
                if (page != null && page > 0 && page <= widget.totalPage) {
                  Navigator.pop(context);
                  _changePage(page - 1); // Konversi ke index 0
                }
              },
              child: const Text("Pergi", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _darkMode ? bgDark : bgLight;
    final fgColor = _darkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,

      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "NRM",
              style: TextStyle(fontFamily: 'Serif', fontSize: 14, color: Colors.white70),
            ),
            Text(
              "Halaman ${_currentPage + 1}",
              style: const TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Bookmark
          IconButton(
            icon: Icon(
              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _bookmarked ? accentGold : Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
          // Search
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchPage,
          ),
          // Zoom
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _showZoomSettings,
          ),
          // Dark Mode
          IconButton(
            icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              setState(() => _darkMode = !_darkMode);
              prefs.setBool('nrm_dark', _darkMode);
            },
          ),
        ],
      ),

      // --- BODY GAMBAR ---
      body: Center(
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 1.0,
          maxScale: 5.0,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _darkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: _darkMode ? [] : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            // Pastikan path gambar sesuai dengan yang ada di assets
            // Contoh: assets/images/nrm/1.png
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                // Perhatikan: Folder 'assets/nrm/' dan ekstensi '.jpg'
                // Dan hapus '+ 1' jika file dimulai dari 0.jpg
                'assets/nrm/$_currentPage.jpg', 
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      // Tampilkan path yang dicari agar mudah debug
                      Text(
                        "Gagal memuat:\nassets/nrm/$_currentPage.jpg", 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontFamily: 'Serif'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION (Prev / Next) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: primaryNavy,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Mundur
            ElevatedButton.icon(
              onPressed: _currentPage > 0 ? () => _changePage(_currentPage - 1) : null,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text("Sebelumnya"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: primaryNavy,
                disabledBackgroundColor: Colors.grey,
              ),
            ),

            // Indikator Halaman
            Text(
              "${_currentPage + 1} / ${widget.totalPage}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif',
              ),
            ),

            // Tombol Maju
            ElevatedButton.icon(
              onPressed: _currentPage < widget.totalPage - 1 ? () => _changePage(_currentPage + 1) : null,
              // Tukar posisi icon agar di kanan
              icon: const SizedBox.shrink(), 
              label: Row(
                children: const [
                  Text("Lanjut"),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: primaryNavy,
                disabledBackgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}