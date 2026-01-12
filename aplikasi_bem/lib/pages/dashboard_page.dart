import 'package:flutter/material.dart';

// --- IMPORT SESUAI STRUKTUR FOLDER BARU ---
import 'landing_page.dart'; // Tetap di folder pages

// Fitur BEM
import '../features/bem/bem_page.dart'; 

// Fitur Doa (Dashboard Doa)
import '../features/doa/dashboard_doa_page.dart'; 

// Fitur NRM
// Sesuai screenshot, file selection ada di dalam nrm_merah 
// (Atau sesuaikan jika Anda memindahkannya ke features/nrm/)
import '../features/nrm/nrm_selection_page.dart'; 
// Jika file NrmSelectionPage ada di features/nrm/, gunakan:
// import '../features/nrm/nrm_selection_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- PALET WARNA ---
  final Color primaryNavy = const Color(0xFF0D1B2A);
  final Color secondaryNavy = const Color(0xFF1B263B);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color bgWhite = const Color(0xFFF4F6F8);

  // Fungsi tombol Back (Kembali ke Landing Page)
  void _goBackToLanding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _goBackToLanding();
      },
      child: Scaffold(
        backgroundColor: bgWhite,
        floatingActionButton: null, 

        body: Column(
          children: [
            // ==========================================
            // 1. HEADER (GRADIENT NAVY & LOGO)
            // ==========================================
            Container(
              padding: const EdgeInsets.only(
                  top: 50, bottom: 25, left: 20, right: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryNavy, secondaryNavy],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryNavy.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Tombol Back
                      IconButton(
                        onPressed: _goBackToLanding,
                        icon: Icon(Icons.arrow_back_ios_new, color: accentGold, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(), 
                      ),
                      
                      const SizedBox(width: 15), 

                      // Logo Methodist
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accentGold, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 24, 
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/logo/logo_methodist.png'),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 15),
                      
                      // Teks Sambutan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Syalom, Selamat Datang di",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontFamily: 'Serif',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Dashboard\nMethodist",
                              style: TextStyle(
                                color: accentGold,
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. GRID MENU (CARD)
            // ==========================================
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(25),
                crossAxisCount: 2, 
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9,
                children: [
                  // 1. BUKU ENDE (Arahkan ke BemPage)
                  _menuCard(
                    "Buku Ende", "Puji-pujian", Icons.library_music_rounded, Colors.blue.shade900,
                    // Pastikan nama class di bem_page.dart adalah BemPage atau BukuEndePage
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BukuEndePage())),
                  ),
                  
                  // 2. KUMPULAN DOA (Arahkan ke DashboardDoaPage)
                  _menuCard(
                    "Doa-Doa", "Gereja Methodist", Icons.volunteer_activism_rounded, Colors.teal.shade800,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardDoaPage())),
                  ),
                  
                  // 3. NRM (Arahkan ke NrmSelectionPage)
                  _menuCard(
                    "NRM", "Nyanyian Rohani", Icons.menu_book_rounded, Colors.brown.shade700,
                    // Pastikan nama class di nrm_selection_page.dart adalah NrmSelectionPage
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NrmSelectionPage())),
                  ),
                ],
              ),
            ),

            // FOOTER
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Gereja Methodist Indonesia",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET CARD
  Widget _menuCard(
    String title,
    String desc,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isLocked = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur ini sedang dalam pengembangan!", textAlign: TextAlign.center),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isLocked ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isLocked ? Colors.grey.shade300 : Colors.grey.shade100),
            boxShadow: isLocked
                ? []
                : [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isLocked
                      ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400])
                      : LinearGradient(
                          colors: [color.withOpacity(0.8), color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: isLocked ? [] : [
                    BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey.shade600 : primaryNavy,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isLocked ? Colors.grey.shade500 : Colors.grey.shade600,
                  fontFamily: 'Serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}