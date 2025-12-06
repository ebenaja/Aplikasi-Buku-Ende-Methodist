import 'package:flutter/material.dart';
import 'home_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background dibuat gradasi Biru Tua agar mirip tekstur kulit buku
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A), // Biru sangat gelap (pojok kiri atas)
              Color(0xFF1B263B), // Biru dongker agak terang (tengah)
              Color(0xFF0D1B2A), // Kembali gelap (pojok kanan bawah)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), // Dorong konten agak ke tengah

              // 1. JUDUL ATAS (ENDE Puji-pujian)
              const Text(
                "ENDE",
                style: TextStyle(
                  fontFamily: 'Serif', // Font kaki mirip buku
                  fontSize: 42,
                  fontWeight: FontWeight.w900, // Sangat tebal
                  color: Color(0xFFD4AF37), // WARNA EMAS (Metallic Gold)
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))
                  ],
                ),
              ),
              const Text(
                "Puji-pujian",
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37), // WARNA EMAS
                  height: 0.8, // Jarak antar baris dirapatkan dikit
                  shadows: [
                    Shadow(blurRadius: 2, color: Colors.black, offset: Offset(1, 1))
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // 2. LOGO ASLI (METHODIST)
              // Pastikan file 'logo_methodist.png' ada di folder 'assets/logo/'
              SizedBox(
                height: 180, // Ukuran logo proporsional
                width: 180,
                child: Image.asset(
                  'assets/logo/logo_methodist.png',
                  fit: BoxFit.contain, // Agar gambar tidak terpotong
                  errorBuilder: (context, error, stackTrace) {
                    // Jaga-jaga jika gambar gagal loading, tampilkan ikon warning (bukan error merah)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                        const SizedBox(height: 5),
                        Text(
                          "Gambar tidak ditemukan\nCek pubspec.yaml",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 10),
                        )
                      ],
                    );
                  },
                ),
              ),

              const Spacer(flex: 2),

              // 3. TEKS BAWAH (GEREJA METHODIST INDONESIA)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "GEREJA METHODIST INDONESIA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37), // Emas
                    letterSpacing: 1.5, // Huruf agak renggang biar elegan
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

              // 4. TOMBOL BUKA
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Pindah ke Halaman Utama
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  icon: const Icon(Icons.book_outlined, color: Color(0xFF0D1B2A)),
                  label: const Text("BUKA BUKU"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37), // Tombol Emas
                    foregroundColor: const Color(0xFF0D1B2A), // Teks Biru Gelap
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}