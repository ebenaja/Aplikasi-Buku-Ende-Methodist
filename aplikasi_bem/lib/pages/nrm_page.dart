import 'package:flutter/material.dart';
import 'nrm_detail_page.dart';

class NrmPage extends StatefulWidget {
  const NrmPage({super.key});

  @override
  State<NrmPage> createState() => _NrmPageState();
}

class _NrmPageState extends State<NrmPage> {
  // --- PALET WARNA ---
  final Color primaryNavy = const Color(0xFF0D1B2A);
  final Color secondaryNavy = const Color(0xFF1B263B);
  final Color accentGold = const Color(0xFFD4AF37);
  final Color bgPaper = const Color(0xFFF8F9FA);

  // Total NRM (Sesuai kode lama Anda)
  final int totalNRM = 298;

  late List<int> nrmList;
  late List<int> filteredList;

  @override
  void initState() {
    super.initState();
    // Generate list nomor 0 sampai 297
    nrmList = List.generate(totalNRM, (i) => i);
    filteredList = List.from(nrmList);
  }

  // Fungsi Pencarian
  void _runSearch(String keyword) {
    final key = keyword.trim();
    setState(() {
      if (key.isEmpty) {
        filteredList = List.from(nrmList);
      } else {
        filteredList = nrmList
            .where((i) => (i + 1).toString().contains(key))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPaper,
      
      // Hapus AppBar standar untuk Custom Header
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryNavy,
        elevation: 0,
      ),

      body: Column(
        children: [
          // ==========================================
          // 1. HEADER (BACK BUTTON & SEARCH)
          // ==========================================
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25, top: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryNavy, secondaryNavy],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BARIS JUDUL & TOMBOL BACK
                Row(
                  children: [
                    // Tombol Kembali
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new, color: accentGold, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 15),
                    
                    // Ikon
                    Icon(Icons.menu_book_rounded, color: accentGold, size: 28),
                    const SizedBox(width: 10),
                    
                    // Judul
                    const Expanded(
                      child: Text(
                        "NRM Methodist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // KOLOM PENCARIAN
                TextField(
                  keyboardType: TextInputType.number, // Keyboard Angka
                  onChanged: _runSearch,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Cari nomor NRM...",
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: primaryNavy),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. LIST LAGU
          // ==========================================
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        Text(
                          "Nomor tidak ditemukan",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final nrmIndex = filteredList[index];
                      final displayNum = nrmIndex + 1;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NrmDetailPage(
                                    index: nrmIndex,
                                    totalPage: totalNRM,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  // KOTAK NOMOR EMAS
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: accentGold.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$displayNum",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Serif',
                                        color: primaryNavy,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 15),
                                  
                                  // JUDUL NRM
                                  Expanded(
                                    child: Text(
                                      "Nyanyian Rohani No. $displayNum",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: primaryNavy,
                                        fontFamily: 'Serif',
                                      ),
                                    ),
                                  ),
                                  
                                  // PANAH KANAN
                                  Icon(Icons.chevron_right_rounded, size: 24, color: Colors.grey.shade400),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}