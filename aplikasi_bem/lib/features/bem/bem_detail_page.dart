import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongDetailPage extends StatefulWidget {
  final Map<String, dynamic> song;

  const SongDetailPage({super.key, required this.song});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  // --- AUDIO STATE ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // --- UI STATE ---
  double _lyricFontSize = 18.0;
  double _noteFontSize = 16.0;
  bool _showPlayer = false;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  // 1. SETUP AUDIO PLAYER
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  // --- 2. LOGIC PLAY AUDIO ---
  Future<void> _playAudio() async {
    final String fileName = "${widget.song['number']}.mp4";
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.setSource(AssetSource('BEM/BEM_audio/$fileName'));
        final duration = await _audioPlayer.getDuration();
        if (duration != null) setState(() => _duration = duration);
        await _audioPlayer.resume();
        setState(() => _showPlayer = true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Audio belum tersedia"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- 3. FUNGSI PENGATURAN TEKS (ZOOM) ---
  void _showTextSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(25),
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
                          min: 14.0, max: 34.0,
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
                      const Icon(Icons.text_fields, size: 30, color: Colors.black),
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

  // --- LOGIC RENDER UI ---
  bool _isImage(String line) => line.contains("![") && line.contains("](") && line.contains(")");
  
  bool _isMusicalNote(String line) {
    final RegExp notePattern = RegExp(r'^[\d\s\./]+$');
    return line.contains('/') && line.contains('.') || notePattern.hasMatch(line.trim());
  }
  
  bool _isHeader(String line) {
    if (line.trim().isEmpty) return false;
    if (line.contains('=')) return true;
    if (line.contains('No.')) return true;
    if (line == line.toUpperCase() && line.length < 40 && !RegExp(r'\d').hasMatch(line)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryNavy = const Color(0xFF0D1B2A);
    final Color accentGold = const Color(0xFFD4AF37);
    final Color bgPaper = const Color(0xFFFDFBF7);

    // Ambil lirik mentah
    final List<String> lines = widget.song['lyrics'].toString().split('\n');

    return Scaffold(
      backgroundColor: bgPaper,
      appBar: AppBar(
        title: Text("BEM ${widget.song['number']}", style: const TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // TOMBOL PLAY AUDIO
          IconButton(
            icon: Icon(_showPlayer ? Icons.volume_up_rounded : Icons.volume_off_outlined, color: _showPlayer ? accentGold : Colors.white),
            onPressed: () {
              if (!_showPlayer) _playAudio();
              setState(() => _showPlayer = !_showPlayer);
            },
          ),
          // TOMBOL ZOOM TEKS
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: _showTextSettings,
          ),
        ],
      ),
      
      // MAIN BODY: LISTVIEW SEDERHANA (HEADER + LIRIK)
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(24, 20, 24, _showPlayer ? 180 : 30),
        physics: const BouncingScrollPhysics(),
        itemCount: lines.length + 1, // +1 untuk Header
        itemBuilder: (context, index) {
          
          // === BAGIAN 1: HEADER LAGU (Index 0) ===
          if (index == 0) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentGold.withOpacity(0.5)),
                  ),
                  child: Text(
                    "No. ${widget.song['number']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryNavy, fontFamily: 'Serif'),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.song['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, fontFamily: 'Serif', color: primaryNavy, height: 1.2),
                ),
                const SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    if (widget.song['key_note'] != null)
                      Chip(label: Text(widget.song['key_note']), backgroundColor: Colors.white),
                    if (widget.song['category'] != null)
                      Chip(label: Text(widget.song['category']), backgroundColor: Colors.white),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: Divider(color: accentGold.withOpacity(0.3), thickness: 1),
                ),
              ],
            );
          }

          // === BAGIAN 2: ISI LIRIK (Index > 0) ===
          String cleanLine = lines[index - 1].trimRight();
          
          // Bersihkan kode timestamp {00:00} dari tampilan agar tidak kotor
          cleanLine = cleanLine.replaceAll(RegExp(r'\{(\d+):(\d+)\}'), '').trim();

          if (cleanLine.isEmpty) return const SizedBox(height: 12);
          if (cleanLine.trim() == widget.song['number'].toString()) return const SizedBox.shrink();

          // Render sesuai tipe konten
          if (_isImage(cleanLine)) {
            final RegExp imgExp = RegExp(r'!\[.*?\]\((.*?)\)');
            final String imagePath = imgExp.firstMatch(cleanLine)?.group(1)?.trim() ?? "";
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (_,__,___) => const SizedBox()),
            );
          } 
          else if (_isMusicalNote(cleanLine)) {
            return Text(cleanLine, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Courier', fontSize: _noteFontSize, fontWeight: FontWeight.bold, color: primaryNavy));
          } 
          else if (_isHeader(cleanLine)) {
            return Padding(padding: const EdgeInsets.symmetric(vertical: 15.0), child: Text(cleanLine, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])));
          } 
          else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(cleanLine, textAlign: TextAlign.left, style: TextStyle(fontSize: _lyricFontSize, fontFamily: 'Serif', height: 1.6, color: Colors.black87)),
            );
          }
        },
      ),

      // BOTTOM SHEET PLAYER
      bottomSheet: _showPlayer ? Container(
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Putar Audio", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(_formatTime(_position), style: const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), activeTrackColor: accentGold, thumbColor: accentGold),
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
                  onTap: () => _playAudio(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: accentGold, shape: BoxShape.circle),
                    child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: primaryNavy, size: 32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : null,
    );
  }
}
