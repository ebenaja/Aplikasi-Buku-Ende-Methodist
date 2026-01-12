import 'package:flutter/material.dart';

class PengakuanImanRasuliPage extends StatefulWidget {
  const PengakuanImanRasuliPage({super.key});

  @override
  State<PengakuanImanRasuliPage> createState() =>
      _PengakuanImanRasuliPageState();
}

class _PengakuanImanRasuliPageState extends State<PengakuanImanRasuliPage> {
  // Ukuran Font Default
  double _fontSize = 20.0;

  // Warna Tema
  final Color primaryNavy = const Color(0xFF0D1B2A);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color paperColor = const Color(0xFFFDFBF7);

  // --- FUNGSI TITLE CASE ---
  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.splitMapJoin(
      RegExp(r'(\s+|\n)'),
      onMatch: (m) => m.group(0)!,
      onNonMatch: (word) {
        if (word.isEmpty) return "";
        // Ubah huruf pertama jadi besar, sisanya kecil
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      },
    );
  }

  // Fungsi Pengaturan Zoom
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
                          value: _fontSize,
                          min: 14.0,
                          max: 34.0,
                          activeColor: primaryNavy,
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (value) {
                            setModalState(() {});
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.text_fields, size: 30, color: Colors.black),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Ukuran: ${_fontSize.toInt()}",
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
    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        title: const Text(
          "Pengakuan Iman Rasuli",
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            tooltip: "Atur Ukuran Teks",
            onPressed: _showTextSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            // 1. HEADER ICON (Verified User / Shield)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentGold.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
                border: Border.all(color: accentGold, width: 2),
              ),
              child: Icon(Icons.verified_user_rounded, size: 50, color: primaryNavy),
            ),

            const SizedBox(height: 25),

            // 2. KARTU ISI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryNavy.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(
                  color: accentGold.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Rata Kiri
                children: [
                  Center(
                    child: Text(
                      "PENGAKUAN IMAN RASULI",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: accentGold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BAGIAN 1: ALLAH BAPA
                  Text(
                    toTitleCase(
                      "Aku percaya kepada Allah, Bapa yang Mahakuasa, Khalik langit dan bumi."
                    ),
                    textAlign: TextAlign.left,
                    style: _textStyle(primaryNavy),
                  ),

                  _divider(accentGold),

                  // BAGIAN 2: YESUS KRISTUS
                  Text(
                    toTitleCase(
                      "Dan kepada Yesus Kristus, Anak-Nya yang tunggal, Tuhan kita,\n"
                      "Yang dikandung dari Roh Kudus, lahir dari anak dara Maria,\n"
                      "Menderita sengsara di bawah pemerintahan Pontius Pilatus,\n"
                      "Disalibkan, mati dan dikuburkan, turun ke dalam kerajaan maut;\n"
                      "Pada hari yang ketiga bangkit pula dari antara orang mati;\n"
                      "Naik ke sorga, duduk di sebelah kanan Allah, Bapa yang Mahakuasa;\n"
                      "Dan dari sana Ia akan datang untuk menghakimi orang yang hidup dan yang mati."
                    ),
                    textAlign: TextAlign.left,
                    style: _textStyle(primaryNavy),
                  ),

                  _divider(accentGold),

                  // BAGIAN 3: ROH KUDUS & GEREJA
                  Text(
                    toTitleCase(
                      "Aku percaya kepada Roh Kudus;\n"
                      "Gereja yang kudus dan am;\n"
                      "Persekutuan orang kudus;\n"
                      "Pengampunan dosa;\n"
                      "Kebangkitan tubuh;\n"
                      "Dan hidup yang kekal."
                    ),
                    textAlign: TextAlign.left,
                    style: _textStyle(primaryNavy),
                  ),

                  const SizedBox(height: 30),

                  // AMIN
                  Center(
                    child: Text(
                      "Amin.",
                      style: TextStyle(
                        fontSize: _fontSize + 4,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Serif',
                        color: primaryNavy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget Garis Pemisah
  Widget _divider(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Divider(
        color: color.withOpacity(0.3),
        thickness: 1,
      ),
    );
  }

  // Style Text Custom
  TextStyle _textStyle(Color color) {
    return TextStyle(
      fontSize: _fontSize,
      fontFamily: 'Serif',
      height: 1.6, // Jarak antar baris
      color: color,
    );
  }
}