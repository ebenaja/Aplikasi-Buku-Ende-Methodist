import 'package:flutter/material.dart';
// Import file doa yang sudah Anda pecah
import 'doa_bapa_kami_page.dart';
import 'pengakuan_iman_rasuli_page.dart';
import 'doa_pengampunan_dosa_page.dart';

class DashboardDoaPage extends StatelessWidget {
  const DashboardDoaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    final Color primaryNavy = const Color(0xFF0D1B2A);
    //final Color secondaryNavy = const Color(0xFF1B263B);
    final Color accentGold = const Color(0xFFD4AF37);
    final Color bgWhite = const Color(0xFFF4F6F8);

    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        title: const Text("Kumpulan Doa", style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // HEADER KECIL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: BoxDecoration(
              color: primaryNavy,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Icon(Icons.volunteer_activism, size: 50, color: accentGold),
                const SizedBox(height: 10),
                const Text(
                  "Doa & Pengakuan Iman",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // LIST MENU DOA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildDoaMenu(
                  context,
                  "Doa Bapa Kami",
                  "Doa yang diajarkan Tuhan Yesus",
                  Icons.volunteer_activism_rounded,
                  Colors.teal.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoaBapaKamiPage())),
                ),
                _buildDoaMenu(
                  context,
                  "Pengakuan Iman Rasuli",
                  "Dasar iman percaya Kristen",
                  Icons.verified_user_rounded,
                  Colors.indigo.shade900,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PengakuanImanRasuliPage())),
                ),
                _buildDoaMenu(
                  context,
                  "Pengakuan Dosa",
                  "Doa pertobatan pribadi",
                  Icons.favorite_rounded,
                  Colors.red.shade800,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoaPengampunanDosaPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET CARD MENU KHUSUS DOA
  Widget _buildDoaMenu(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    Color color, 
    VoidCallback onTap
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0D1B2A),
            fontFamily: 'Serif',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}