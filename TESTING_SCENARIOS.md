# 🧪 Testing Scenarios & Usage Guide

## 1. BEM Detail Page Testing

### Scenario 1.1: Audio Playback (MP4)
**Steps:**
1. Navigate ke Buku Ende → pilih lagu nomor 1
2. Lihat lagu detail page
3. Click tombol volume icon (ikon speaker) untuk show player
4. Click play button di bottom sheet
5. Drag slider untuk seek ke posisi lain
6. Click pause button untuk pause

**Expected Results:**
- ✅ Audio dimulai dari file `assets/mp4/1.mp4`
- ✅ Duration dan position menampilkan waktu dengan format MM:SS
- ✅ Slider progress mengikuti playback position
- ✅ Play/pause toggle berfungsi
- ✅ Bottom sheet visible saat _showPlayer = true

### Scenario 1.2: MIDI Toggle
**Steps:**
1. Saat di detail page, click ikon musik di AppBar (MIDI toggle button)
2. Lihat icon berubah warna (dari white ke gold ketika aktif)
3. Click play button
4. Amati source audio yang digunakan

**Expected Results:**
- ✅ Icon berubah dari `Icons.music_note_outlined` ke `Icons.music_note_rounded`
- ✅ Color berubah ke gold ketika MIDI aktif
- ✅ Audio load dari `assets/midi/1.mid` (jika tersedia)
- ✅ Jika file tidak tersedia, SnackBar error muncul
- ✅ Player label menampilkan "Putar MIDI" atau "Putar MP4"

### Scenario 1.3: Text Zoom
**Steps:**
1. Click ikon text zoom di AppBar
2. Bottom sheet muncul dengan slider
3. Drag slider dari kiri ke kanan (14 → 34)
4. Amati ukuran text lirik berubah
5. Text nota musik juga ikut membesar (size - 2)

**Expected Results:**
- ✅ Slider range 14.0 - 34.0
- ✅ Lirik text berubah ukuran dengan smooth transition
- ✅ Nota musik selalu 2pt lebih kecil dari lirik
- ✅ Perubahan apply secara real-time

### Scenario 1.4: Lyric Rendering
**Steps:**
1. Scroll melalui lirik lagu
2. Amati berbagai tipe konten

**Expected Results:**
- ✅ Text normal → rendered dengan _lyricFontSize, color black87
- ✅ Nota musik (contains `/` dan `.`) → centered, Courier font, bold
- ✅ Header (ALL CAPS < 40 chars) → centered, grey, small
- ✅ Image markdown (`![alt](path)`) → Image.asset rendered
- ✅ Empty lines → SizedBox dengan height 12pt

### Scenario 1.5: Bottom Sheet Auto-close
**Steps:**
1. Buka player (click volume icon)
2. Scroll lirik ke bawah
3. Amati padding adjust

**Expected Results:**
- ✅ ListView padding bottom = 180pt ketika player show
- ✅ ListView padding bottom = 30pt ketika player hidden
- ✅ Content tidak ter-cover oleh player

---

## 2. NRM Detail Page Testing

### Scenario 2.1: PDF Viewer & Swipe
**Steps:**
1. Navigate ke NRM Methodist → pilih nomor 1
2. Lihat PDF halaman 1 menampilkan
3. Swipe ke kanan untuk halaman berikutnya
4. Amati perubahan title nomor

**Expected Results:**
- ✅ PDF load dari `assets/NRM_teks_.pdf/1.pdf`
- ✅ Title berubah ke "No. 2" setelah swipe
- ✅ PDF viewer support double-tap zoom
- ✅ onPageChanged dipanggil saat berpindah halaman
- ✅ Smooth animation saat swipe

### Scenario 2.2: Bookmark Toggle
**Steps:**
1. Di halaman NRM detail, click bookmark icon di AppBar
2. Icon berubah warna ke gold
3. SnackBar "Ditandai" muncul
4. Navigate ke halaman lain kemudian kembali
5. Bookmark state masih terpilih (persisten)

**Expected Results:**
- ✅ Icon berubah dari outline ke filled
- ✅ Color berubah ke gold ketika bookmarked
- ✅ SnackBar muncul (500ms duration)
- ✅ SharedPreferences menyimpan `bookmark_nrm_0` = true/false
- ✅ Bookmark state persisten saat reload page

### Scenario 2.3: Audio Playback (MP3)
**Steps:**
1. Click volume icon untuk show player
2. Click play button
3. Audio bermain dari file MP3

**Expected Results:**
- ✅ Audio load dari `assets/nrm_audio/1.mp3`
- ✅ Duration dan position display dengan format MM:SS
- ✅ Slider progress update real-time
- ✅ Player label: "Putar MP3 (NRM 1)"

### Scenario 2.4: MIDI Toggle
**Steps:**
1. Click ikon musik toggle di AppBar
2. Icon berubah dan berubah warna
3. Click play button
4. Audio load dari MIDI source

**Expected Results:**
- ✅ Icon toggle antara music_note_outlined dan music_note_rounded
- ✅ Color toggle antara white dan gold
- ✅ Audio source switch ke `assets/nrm_midi/1.mid`
- ✅ Player label: "Putar MIDI (NRM 1)"
- ✅ MIDI state di-reset saat berpindah halaman

### Scenario 2.5: Search & Jump to Page
**Steps:**
1. Click search icon di AppBar
2. Dialog muncul dengan title "Lompat ke NRM"
3. Enter nomor "50" di input field
4. Click "Pergi" button
5. Observe page jump ke halaman 49 (0-based index)

**Expected Results:**
- ✅ Dialog muncul dengan TextField
- ✅ Input field hanya accept angka (TextInputType.number)
- ✅ _pageController.jumpToPage(49) dipanggil
- ✅ PDF viewer langsung menampilkan halaman 50
- ✅ Title update ke "No. 50"
- ✅ Validation: jika angka > 298 atau < 1, tidak ada aksi

### Scenario 2.6: Last Read Persistence
**Steps:**
1. Navigate ke NRM halaman 45
2. Close aplikasi (kill process)
3. Buka ulang aplikasi
4. Navigate ke NRM Methodist
5. Amati halaman terakhir yang dibaca

**Expected Results:**
- ✅ _saveLastRead() dipanggil di initState dan _onPageChanged
- ✅ SharedPreferences menyimpan `last_read_nrm` = 44 (0-based)
- ✅ Next time buka, bisa restore ke halaman terakhir (future feature)

### Scenario 2.7: Page Change Cleanup
**Steps:**
1. Play audio di halaman 1
2. Swipe ke halaman 2
3. Observe audio berhenti dan player hide

**Expected Results:**
- ✅ _audioPlayer.stop() dipanggil
- ✅ _isPlaying = false
- ✅ _position = Duration.zero
- ✅ _showPlayer = false
- ✅ _useMidi = false (reset toggle)
- ✅ _pdfViewerController.zoomLevel = 1.0 (reset zoom)
- ✅ _loadState() dipanggil untuk load bookmark state

---

## 3. Doa Gabungan Page Testing

### Scenario 3.1: Tab Navigation
**Steps:**
1. Navigate ke Doa-Doa card di dashboard
2. DoaGabunganPage muncul dengan 3 tab
3. Tab 1: "Doa Bapa" (Doa Bapa Kami)
4. Click Tab 2: "Pengakuan Iman" (Pengakuan Iman Rasuli)
5. Click Tab 3: "Doa Dosa" (Doa Pengampunan Dosa)

**Expected Results:**
- ✅ TabController initialized dengan length: 3
- ✅ TabBar indicator berubah ke gold saat switch tab
- ✅ Content smooth transition antar tab
- ✅ ScrollPosition independent per tab

### Scenario 3.2: Text Zoom (Global for All Tabs)
**Steps:**
1. Di Tab 1, click text zoom icon
2. Slider muncul dengan range 14-34
3. Adjust slider ke 28
4. Switch ke Tab 2
5. Text size di Tab 2 juga 28 (not reset)

**Expected Results:**
- ✅ _fontSize state persisten antar tab
- ✅ Zoom berlaku ke semua 3 doa tabs
- ✅ Display "Ukuran: 28" di bottom slider

### Scenario 3.3: Doa Content Rendering
**Steps:**
1. Tab 1: Scroll melalui Doa Bapa Kami
2. Amati struktur: Pembukaan → Divider → Permohonan → Divider → Doksologi → Divider → Amin

**Expected Results:**
- ✅ Setiap section text dengan toTitleCase() formatting
- ✅ Divider gold dengan opacity 0.3 antar section
- ✅ Icon di atas card (volunteer_activism untuk Doa Bapa)
- ✅ Card styling: white background, border gold 1.5pt, shadow
- ✅ "Amin" di bawah dengan fontSize _fontSize + 4, fontWeight w900

### Scenario 3.4: All Doa Content Verification

**Tab 2 (Pengakuan Iman Rasuli):**
- ✅ Icon: verified_user_rounded
- ✅ 3 sections: Allah Bapa, Yesus Kristus, Roh Kudus
- ✅ Content dengan proper formatting

**Tab 3 (Doa Pengampunan Dosa):**
- ✅ Icon: favorite_rounded (hati)
- ✅ 4 sections: Pembukaan, Pengakuan, Permohonan, Penutup
- ✅ Content dengan proper formatting

### Scenario 3.5: ScrollView Performance
**Steps:**
1. Di salah satu tab, scroll naik-turun dengan cepat
2. Amati smoothness

**Expected Results:**
- ✅ SingleChildScrollView dengan BouncingScrollPhysics
- ✅ Smooth scrolling tanpa jank
- ✅ No rebuild lag saat scroll

---

## 4. Dashboard Testing

### Scenario 4.1: Menu Cards Display
**Steps:**
1. Open app → land on Dashboard
2. Amati 3 menu cards (dari 5 sebelumnya)

**Expected Results:**
- ✅ Card 1: "Buku Ende" - Puji-pujian (blue icon: library_music)
- ✅ Card 2: "Doa-Doa" - Gereja Methodist (teal icon: volunteer_activism)
- ✅ Card 3: "NRM" - Nyanyian Rohani (brown icon: menu_book)
- ✅ Layout: 2 columns, 20pt spacing
- ✅ Each card: 0.9 aspect ratio

### Scenario 4.2: Navigation
**Steps:**
1. Click "Buku Ende" card → navigate ke bem_page
2. Click back → return ke dashboard
3. Click "Doa-Doa" card → navigate ke doa_gabungan_page
4. Click back → return ke dashboard
5. Click "NRM" card → navigate ke nrm_page

**Expected Results:**
- ✅ Each navigation smooth
- ✅ Navigator routes correct
- ✅ Back button work properly

### Scenario 4.3: Back Button & PopScope
**Steps:**
1. Click back button di header
2. Observe navigation ke LandingPage

**Expected Results:**
- ✅ _goBackToLanding() dipanggil
- ✅ Navigator.pushReplacement (tidak push, tapi replace)
- ✅ Back button tidak bisa kembali ke dashboard (PopScope)

---

## 5. BEM Page (List) Testing

### Scenario 5.1: Search Functionality
**Steps:**
1. Di Buku Ende page, type "1" di search field
2. List filter menampilkan lagu dengan nomor 1
3. Type "Nang" (judul dimulai dengan)
4. List filter menampilkan matching songs

**Expected Results:**
- ✅ _runFilter() called dengan keyword
- ✅ DatabaseHelper.searchSongs() executed
- ✅ List update real-time
- ✅ Clear search (delete all) → restore full list

### Scenario 5.2: List Item Styling Consistency
**Steps:**
1. Scroll through list
2. Check setiap item

**Expected Results:**
- ✅ Item container: white bg, border radius 12pt
- ✅ Shadow: 0.08 opacity, 4pt blur, 2pt offset
- ✅ Padding: 12pt horizontal, 12pt vertical
- ✅ Number box: 45x45pt, border radius 10pt, gold bg 0.15 opacity
- ✅ Title: 2 lines max, overflow ellipsis
- ✅ Chevron: grey.shade400 color

---

## 6. NRM Page (List) Testing

### Scenario 6.1: Number Search
**Steps:**
1. Type "100" di search field
2. List filter menampilkan NRM No. 100 saja

**Expected Results:**
- ✅ _runSearch() dengan numeric filtering
- ✅ (0 + 1).toString().contains(keyword)
- ✅ Smooth filter update

### Scenario 6.2: Empty State
**Steps:**
1. Type "999" (no match)
2. Amati empty state

**Expected Results:**
- ✅ Icon: search_off
- ✅ Text: "Nomor tidak ditemukan"
- ✅ Centered display

---

## 7. Performance & Memory Testing

### Scenario 7.1: Rapid Audio Toggle
**Steps:**
1. Toggle MIDI/MP4 10x rapidly
2. Monitor memory usage
3. Check no crashes

**Expected Results:**
- ✅ No memory leak
- ✅ State update smooth
- ✅ No crashes atau freezes

### Scenario 7.2: Long Lyric Scroll
**Steps:**
1. Open lagu dengan lirik panjang (100+ lines)
2. Scroll naik-turun 10x
3. Check performance

**Expected Results:**
- ✅ ListView.builder efficient (lazy load)
- ✅ No jank atau frame drop
- ✅ Smooth 60fps scrolling

### Scenario 7.3: PDF Page Swipe Performance
**Steps:**
1. Swipe 20x antar halaman
2. Monitor performance
3. Check zoom level reset

**Expected Results:**
- ✅ Smooth swipe animation
- ✅ No lag atau freeze
- ✅ Zoom level reset properly

---

## 8. Integration Testing

### Scenario 8.1: Full User Journey 1
```
Dashboard → Buku Ende → Song List → Select Song 1
→ Play MP4 → Zoom text → Read lirik → Back to list
→ Select Song 2 → Toggle MIDI → Play MIDI → Back
→ Back to Dashboard
```

**Expected**: All transitions smooth, no errors, all features work

### Scenario 8.2: Full User Journey 2
```
Dashboard → Doa-Doa → Tab 1: Read Doa Bapa
→ Tab 2: Read Pengakuan Iman → Zoom text (apply all tabs)
→ Tab 3: Read Doa Dosa → Back to Dashboard
```

**Expected**: Tab switching smooth, zoom persisten, no errors

### Scenario 8.3: Full User Journey 3
```
Dashboard → NRM → Search 50 → NRM Detail 50
→ Play MP3 → Bookmark → Swipe to 51
→ Toggle MIDI → Play MIDI → Search jump to 100
→ Back to NRM list → Back to Dashboard
```

**Expected**: All features work, bookmarks persisted, search functional

---

## ✅ Final Checklist

- [ ] All audio files exist in assets folders (MP4, MIDI, MP3)
- [ ] All PDF files exist in assets/NRM_teks_.pdf/
- [ ] Database initialized with all BEM songs
- [ ] SharedPreferences library functional
- [ ] No compilation errors
- [ ] All navigation routes work
- [ ] All buttons responsive and functional
- [ ] All text properly formatted and readable
- [ ] Color scheme consistent (Navy, Gold, Paper)
- [ ] Font sizes appropriate
- [ ] Performance smooth and no memory leaks
- [ ] State management proper (no data loss on navigation)
- [ ] Error handling graceful (SnackBar for missing files)

---

## 🚀 Deployment Checklist

Before production release:

1. **Assets**
   - [ ] Add all MP4 files to `assets/mp4/`
   - [ ] Add all MIDI files to `assets/midi/`
   - [ ] Add all MP3 files to `assets/nrm_audio/`
   - [ ] Add all NRM MIDI to `assets/nrm_midi/`
   - [ ] Add all PDF files to `assets/NRM_teks_.pdf/`
   - [ ] Add all MD files to `assets/BEM_teks_.md/`

2. **Database**
   - [ ] Populate DatabaseHelper with all BEM songs
   - [ ] Verify search functionality

3. **Testing**
   - [ ] Run all scenarios above
   - [ ] Test on multiple devices
   - [ ] Test on different screen sizes
   - [ ] Test on slow/fast networks (for potential future updates)

4. **Code Quality**
   - [ ] All methods documented
   - [ ] No console errors/warnings
   - [ ] Follow Flutter best practices
   - [ ] Clean code (no debug prints)

5. **Release**
   - [ ] Bump version number
   - [ ] Update changelog
   - [ ] Build APK/IPA
   - [ ] Test signed build

---

**Status**: Ready for testing and deployment! 🎉
