import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:audioplayers/audioplayers.dart';

class NrmBiruDetailPage extends StatefulWidget {
  final int index;
  final int totalPage;

  const NrmBiruDetailPage({
    super.key,
    required this.index,
    required this.totalPage,
  });

  @override
  State<NrmBiruDetailPage> createState() => _NrmBiruDetailPageState();
}

class _NrmBiruDetailPageState extends State<NrmBiruDetailPage> {
  late PageController _pageController;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  
  late int _currentIndex;

  // --- AUDIO STATE ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _showPlayer = false;
  
  final bool _autoPlayNext = true;

  bool _bookmarked = false;

  // --- PALET WARNA (BIRU) ---
  final Color primaryBiru = const Color(0xFF1B4965);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color bgPaper = const Color(0xFFFDFBF7);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
    
    _loadState();
    _saveLastRead();
    _setupAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _setupAudio() {
    _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() { _position = Duration.zero; _isPlaying = false; });
    });
  }

  Future<void> _playAudio() async {
    final String fileName = "${_currentIndex + 1}.mp4";
    final String assetPath = 'NRM/NRM_audio/$fileName';

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.setSource(AssetSource(assetPath));
        final duration = await _audioPlayer.getDuration();
        if (duration != null) setState(() => _duration = duration);
        await _audioPlayer.resume();
        setState(() => _showPlayer = true);
      }
    } catch (e) {
      debugPrint("Error Audio: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Audio belum tersedia"), 
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _onPageChanged(int index) async {
    bool wasPlaying = _isPlaying;
    await _audioPlayer.stop();
    
    setState(() {
      _currentIndex = index;
      _isPlaying = false;
      _position = Duration.zero;
    });

    _pdfViewerController.zoomLevel = 1.0; 
    _saveLastRead();
    _loadState();

    if (wasPlaying && _autoPlayNext) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) _playAudio();
    }
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarked = prefs.getBool('bookmark_nrm_biru_$_currentIndex') ?? false;
    });
  }

  Future<void> _saveLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_read_nrm_biru', _currentIndex);
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _bookmarked = !_bookmarked);
    prefs.setBool('bookmark_nrm_biru_$_currentIndex', _bookmarked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_bookmarked ? "Ditandai" : "Tanda dihapus"), duration: const Duration(milliseconds: 500), backgroundColor: accentGold),
    );
  }

  void _searchPage() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Lompat ke NRM"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Nomor Lagu"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryBiru),
              onPressed: () {
                final page = int.tryParse(controller.text);
                if (page != null && page > 0 && page <= widget.totalPage) {
                  Navigator.pop(context);
                  _pageController.jumpToPage(page - 1);
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
    return Scaffold(
      backgroundColor: bgPaper,

      appBar: AppBar(
        backgroundColor: primaryBiru,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            const Text("NRM Warna Biru", style: TextStyle(fontFamily: 'Serif', fontSize: 12, color: Colors.white70)),
            Text("No. ${_currentIndex + 1}", style: const TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_showPlayer ? Icons.music_note : Icons.music_off_outlined, color: _showPlayer ? accentGold : Colors.white),
            onPressed: () {
              if (!_showPlayer && !_isPlaying) _playAudio();
              setState(() => _showPlayer = !_showPlayer);
            },
          ),
          IconButton(
            icon: Icon(_bookmarked ? Icons.bookmark : Icons.bookmark_border, color: _bookmarked ? accentGold : Colors.white),
            onPressed: _toggleBookmark,
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: _searchPage),
        ],
      ),

      body: GestureDetector(
        onTap: () {
          setState(() {
            _showPlayer = !_showPlayer;
          });
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.totalPage,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBiru.withOpacity(0.15),
                      blurRadius: 15, 
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SfPdfViewer.asset(
                    'assets/NRM/NRM_teks/${index + 1}.pdf',
                    controller: _pdfViewerController,
                    enableDoubleTapZooming: true,
                    pageLayoutMode: PdfPageLayoutMode.single,
                    onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                       debugPrint("Gagal: ${details.description}");
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomSheet: _showPlayer ? Container(
        decoration: BoxDecoration(
          color: primaryBiru,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Putar Musik (NRM ${_currentIndex + 1})", 
              style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Serif')
            ),
            const SizedBox(height: 10),
            
            Row(
              children: [
                Text(_formatTime(_position), style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 10),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3, 
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: accentGold, 
                      inactiveTrackColor: Colors.white24,
                      thumbColor: accentGold,
                      overlayColor: accentGold.withOpacity(0.2),
                    ),
                    child: Slider(
                      min: 0,
                      max: (_duration.inSeconds.toDouble() > 0) ? _duration.inSeconds.toDouble() : 1.0,
                      value: _position.inSeconds.toDouble().clamp(0, (_duration.inSeconds.toDouble() > 0) ? _duration.inSeconds.toDouble() : 1.0),
                      onChanged: (value) async { await _audioPlayer.seek(Duration(seconds: value.toInt())); },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(_formatTime(_duration), style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _playAudio,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentGold, 
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: accentGold.withOpacity(0.4), blurRadius: 15, spreadRadius: 2)
                  ]
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 
                  color: primaryBiru, 
                  size: 34
                ),
              ),
            ),
          ],
        ),
      ) : null,
    );
  }
}
