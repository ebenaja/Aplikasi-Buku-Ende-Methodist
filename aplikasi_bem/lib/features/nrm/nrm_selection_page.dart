import 'package:flutter/material.dart';
import 'nrm_biru/nrm_biru_page.dart';
import 'nrm_merah/nrm_merah_page.dart';

class NrmSelectionPage extends StatelessWidget {
  const NrmSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF0D1B2A);
    const Color accentGold = Color(0xFFD4AF37);
    const Color colorBiru = Color(0xFF1B4965);
    const Color colorMerah = Color(0xFF8B3A3A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      
      appBar: AppBar(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Pilih Nyanyian Rohani",
          style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- CARD NRM WARNA BIRU ---
              _buildNrmCard(
                context: context,
                title: "NRM Warna Biru",
                subtitle: "Nyanyian Rohani Methodist\nEdisi Biru",
                backgroundColor: colorBiru,
                accentColor: accentGold,
                icon: Icons.music_note_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NrmBiruPage()),
                  );
                },
              ),

              const SizedBox(height: 30),

              // --- CARD NRM WARNA MERAH ---
              _buildNrmCard(
                context: context,
                title: "NRM Warna Merah",
                subtitle: "Nyanyian Rohani Methodist\nEdisi Merah",
                backgroundColor: colorMerah,
                accentColor: accentGold,
                icon: Icons.music_note_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NrmMerahPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNrmCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color accentColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Musik
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 48),
            ),

            const SizedBox(height: 20),

            // Judul
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Serif',
              ),
            ),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Buka
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Buka",
                    style: TextStyle(
                      color: Color(0xFF0D1B2A),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0D1B2A)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
