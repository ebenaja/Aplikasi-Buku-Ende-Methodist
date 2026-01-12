# 🔍 Method Call Verification & Usage Map

## bem_detail_page.dart - Method Call Graph

```
_SongDetailPageState
│
├─ initState()
│  └─ _setupAudio()
│     ├─ _audioPlayer.onPlayerStateChanged.listen()
│     ├─ _audioPlayer.onDurationChanged.listen()
│     ├─ _audioPlayer.onPositionChanged.listen()
│     └─ _audioPlayer.onPlayerComplete.listen()
│
├─ build()
│  ├─ AppBar.actions
│  │  ├─ IconButton (MIDI toggle)
│  │  │  └─ onPressed: setState(() => _useMidi = !_useMidi)
│  │  ├─ IconButton (Play/Pause)
│  │  │  └─ onPressed: _playAudio(useMidi: _useMidi)
│  │  └─ IconButton (Text Zoom)
│  │     └─ onPressed: _showTextSettings()
│  │
│  ├─ _showTextSettings()
│  │  └─ showModalBottomSheet()
│  │     └─ Slider.onChanged: setState(() => _lyricFontSize = value)
│  │
│  ├─ ListView.builder
│  │  ├─ index == 0
│  │  │  └─ Header dengan title, nomor, chips
│  │  └─ index > 0
│  │     ├─ cleanLine processing
│  │     ├─ _isImage(cleanLine) → Image.asset()
│  │     ├─ _isMusicalNote(cleanLine) → Text styling musik
│  │     ├─ _isHeader(cleanLine) → Header text styling
│  │     └─ else → Lyric text dengan _lyricFontSize
│  │
│  └─ bottomSheet (conditional _showPlayer)
│     ├─ Slider.onChanged: _audioPlayer.seek()
│     └─ GestureDetector.onTap: _playAudio(useMidi: _useMidi)
│
├─ _playAudio({bool useMidi = false})
│  ├─ if (_isPlaying)
│  │  └─ _audioPlayer.pause()
│  └─ else
│     ├─ _audioPlayer.setSource(AssetSource(...))
│     ├─ _audioPlayer.getDuration()
│     └─ _audioPlayer.resume()
│
├─ _formatTime(Duration duration)
│  └─ return formatted string "MM:SS"
│
├─ _isImage(String line) → bool
├─ _isMusicalNote(String line) → bool
├─ _isHeader(String line) → bool
│
└─ dispose()
   └─ _audioPlayer.dispose()
```

**Method Usage Verification:**
- ✅ `_setupAudio()` - Called once in initState
- ✅ `_playAudio(useMidi)` - Called from 2 places (AppBar button, bottom sheet button)
- ✅ `_showTextSettings()` - Called from AppBar text zoom button
- ✅ `_formatTime()` - Used 2x in bottom sheet for time display
- ✅ `_isImage()` - Used in ListView.builder condition
- ✅ `_isMusicalNote()` - Used in ListView.builder condition
- ✅ `_isHeader()` - Used in ListView.builder condition
- ✅ `dispose()` - Auto-called by Flutter lifecycle

---

## nrm_detail_page.dart - Method Call Graph

```
_NrmDetailPageState
│
├─ initState()
│  ├─ _setupAudio()
│  │  ├─ _audioPlayer.onPlayerStateChanged.listen()
│  │  ├─ _audioPlayer.onDurationChanged.listen()
│  │  ├─ _audioPlayer.onPositionChanged.listen()
│  │  └─ _audioPlayer.onPlayerComplete.listen()
│  ├─ _loadState()
│  │  └─ SharedPreferences.getBool('bookmark_nrm_$_currentIndex')
│  └─ _saveLastRead()
│     └─ SharedPreferences.setInt('last_read_nrm', _currentIndex)
│
├─ build()
│  ├─ AppBar.leading
│  │  └─ IconButton.onPressed: Navigator.pop()
│  │
│  ├─ AppBar.actions
│  │  ├─ IconButton (MIDI toggle)
│  │  │  └─ onPressed: setState(() => _useMidi = !_useMidi)
│  │  ├─ IconButton (Play/Pause)
│  │  │  └─ onPressed: _playAudio(useMidi: _useMidi)
│  │  ├─ IconButton (Bookmark)
│  │  │  └─ onPressed: _toggleBookmark()
│  │  └─ IconButton (Search)
│  │     └─ onPressed: _searchPage()
│  │
│  ├─ PageView.builder
│  │  ├─ itemBuilder: SfPdfViewer.asset()
│  │  └─ onPageChanged: _onPageChanged()
│  │
│  └─ bottomSheet (conditional _showPlayer)
│     ├─ Slider.onChanged: _audioPlayer.seek()
│     └─ GestureDetector.onTap: _playAudio(useMidi: _useMidi)
│
├─ _playAudio({bool useMidi = false})
│  ├─ if (_isPlaying)
│  │  └─ _audioPlayer.pause()
│  └─ else
│     ├─ _audioPlayer.setSource(AssetSource(...))
│     ├─ _audioPlayer.getDuration()
│     └─ _audioPlayer.resume()
│
├─ _onPageChanged(int index)
│  ├─ _audioPlayer.stop()
│  ├─ setState() → update _currentIndex, _isPlaying, _position, _showPlayer, _useMidi
│  ├─ _pdfViewerController.zoomLevel = 1.0
│  ├─ _saveLastRead()
│  └─ _loadState()
│
├─ _loadState()
│  └─ SharedPreferences.getBool('bookmark_nrm_$_currentIndex')
│
├─ _saveLastRead()
│  └─ SharedPreferences.setInt('last_read_nrm', _currentIndex)
│
├─ _toggleBookmark()
│  ├─ setState(() => _bookmarked = !_bookmarked)
│  ├─ SharedPreferences.setBool('bookmark_nrm_$_currentIndex', _bookmarked)
│  └─ showSnackBar()
│
├─ _searchPage()
│  └─ showDialog()
│     ├─ TextEditingController
│     ├─ TextField with keyboardType: TextInputType.number
│     └─ onPressed (Pergi button)
│        └─ _pageController.jumpToPage(page - 1)
│
├─ _formatTime(Duration duration)
│  └─ return formatted string "MM:SS"
│
└─ dispose()
   ├─ _audioPlayer.dispose()
   └─ _pageController.dispose()
```

**Method Usage Verification:**
- ✅ `_setupAudio()` - Called once in initState
- ✅ `_playAudio(useMidi)` - Called from 2 places (AppBar button, bottom sheet button)
- ✅ `_onPageChanged(index)` - Called by PageView.onPageChanged
- ✅ `_loadState()` - Called in initState and _onPageChanged (2 places)
- ✅ `_saveLastRead()` - Called in initState and _onPageChanged (2 places)
- ✅ `_toggleBookmark()` - Called from bookmark button
- ✅ `_searchPage()` - Called from search button
- ✅ `_formatTime()` - Used 2x in bottom sheet for time display
- ✅ `dispose()` - Auto-called by Flutter lifecycle

---

## doa_gabungan_page.dart - Method Call Graph

```
_DoaGabunganPageState (with SingleTickerProviderStateMixin)
│
├─ initState()
│  └─ _tabController = TabController(length: 3, vsync: this)
│
├─ build()
│  ├─ AppBar
│  │  ├─ actions: IconButton (Text Zoom)
│  │  │  └─ onPressed: _showTextSettings()
│  │  │
│  │  └─ bottom: TabBar
│  │     └─ 3 tabs (Doa Bapa, Pengakuan Iman, Doa Dosa)
│  │
│  ├─ _showTextSettings()
│  │  └─ showModalBottomSheet()
│  │     └─ Slider.onChanged: setState(() => _fontSize = value)
│  │
│  └─ TabBarView
│     ├─ Tab 1: _buildDoaCard("Doa Bapa Kami", [...])
│     ├─ Tab 2: _buildDoaCard("Pengakuan Iman Rasuli", [...])
│     └─ Tab 3: _buildDoaCard("Doa Pengampunan Dosa", [...])
│
├─ _buildDoaCard(String title, List<String> sections)
│  ├─ SingleChildScrollView
│  │  └─ Column
│  │     ├─ Icon container (with _divider)
│  │     ├─ Card container
│  │     │  ├─ Title text
│  │     │  ├─ for loop sections
│  │     │  │  ├─ Text(toTitleCase(section[i]))
│  │     │  │  └─ _divider (if not last)
│  │     │  └─ "Amin" text
│  │     └─ SizedBox(height: 50)
│  │
│  └─ Uses:
│     ├─ toTitleCase() - format setiap section
│     ├─ _divider() - antar section
│     └─ _textStyle() - text styling
│
├─ toTitleCase(String text)
│  └─ return formatted text
│
├─ _divider(Color color)
│  └─ return Padding(child: Divider(...))
│
├─ _textStyle(Color color)
│  └─ return TextStyle(...)
│
└─ dispose()
   └─ _tabController.dispose()
```

**Method Usage Verification:**
- ✅ `initState()` - Initialize TabController
- ✅ `_showTextSettings()` - Called from AppBar text zoom button
- ✅ `_buildDoaCard()` - Called 3x in TabBarView children
- ✅ `toTitleCase()` - Called N times untuk format section text
- ✅ `_divider()` - Called N times untuk render dividers
- ✅ `_textStyle()` - Called N times untuk text styling
- ✅ `dispose()` - Auto-called by Flutter lifecycle, cleans up TabController

---

## dashboard_page.dart - Method Call Graph

```
_DashboardPageState
│
├─ _goBackToLanding()
│  └─ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LandingPage()))
│
├─ build()
│  └─ PopScope
│     ├─ onPopInvoked: _goBackToLanding()
│     │
│     └─ Scaffold
│        ├─ AppBar
│        │  └─ IconButton (Back)
│        │     └─ onPressed: _goBackToLanding()
│        │
│        └─ GridView.count
│           ├─ _menuCard("Buku Ende", ..., BukuEndePage)
│           ├─ _menuCard("Doa-Doa", ..., DoaGabunganPage)
│           └─ _menuCard("NRM", ..., NrmPage)
│
├─ _menuCard(String title, String desc, IconData icon, Color color, VoidCallback onTap)
│  └─ return Material(child: InkWell(...))
│
└─ (No custom lifecycle methods needed)
```

**Method Usage Verification:**
- ✅ `_goBackToLanding()` - Called from 2 places (back button, PopScope)
- ✅ `_menuCard()` - Called 3x in GridView children
- ✅ Navigation paths:
  - ✅ BukuEndePage import exists
  - ✅ DoaGabunganPage import exists
  - ✅ NrmPage import exists

---

## bem_page.dart - Method Call Graph

```
_BukuEndePageState
│
├─ initState()
│  └─ _loadSongs()
│     └─ DatabaseHelper.instance.getAllSongs()
│
├─ _loadSongs()
│  └─ setState(() { allSongs = data; isLoading = false; })
│
├─ _runFilter(String keyword)
│  ├─ if (keyword.isEmpty)
│  │  └─ _loadSongs()
│  └─ else
│     └─ DatabaseHelper.instance.searchSongs(keyword)
│
└─ build()
   ├─ TextField
   │  └─ onChanged: _runFilter(value)
   │
   └─ ListView.builder
      ├─ itemBuilder: InkWell
      │  └─ onTap: Navigator.push(context, MaterialPageRoute(builder: (_) => SongDetailPage(song: song)))
      │
      └─ Conditional rendering:
         ├─ isLoading → CircularProgressIndicator
         ├─ allSongs.isEmpty → Empty state
         └─ ListView with consistent list items
```

**Method Usage Verification:**
- ✅ `_loadSongs()` - Called in initState and _runFilter
- ✅ `_runFilter()` - Called from TextField.onChanged
- ✅ No orphaned methods

---

## nrm_page.dart - Method Call Graph

```
_NrmPageState
│
├─ initState()
│  └─ Generate nrmList: List.generate(totalNRM, (i) => i)
│
├─ _runSearch(String keyword)
│  └─ setState(() { filteredList = filtered results })
│
└─ build()
   ├─ TextField
   │  └─ onChanged: _runSearch(value)
   │
   └─ ListView.builder
      ├─ itemBuilder: InkWell
      │  └─ onTap: Navigator.push(context, MaterialPageRoute(builder: (_) => NrmDetailPage(...)))
      │
      └─ Conditional rendering:
         ├─ filteredList.isEmpty → Empty state
         └─ ListView with consistent list items
```

**Method Usage Verification:**
- ✅ `_runSearch()` - Called from TextField.onChanged
- ✅ No orphaned methods

---

## 📊 Summary Statistics

| File | Total Methods | Used Methods | Unused Methods | Status |
|------|---------------|--------------|----------------|--------|
| bem_detail_page.dart | 9 | 9 | 0 | ✅ 100% |
| nrm_detail_page.dart | 8 | 8 | 0 | ✅ 100% |
| doa_gabungan_page.dart | 7 | 7 | 0 | ✅ 100% |
| dashboard_page.dart | 2 | 2 | 0 | ✅ 100% |
| bem_page.dart | 2 | 2 | 0 | ✅ 100% |
| nrm_page.dart | 1 | 1 | 0 | ✅ 100% |

**Overall Status**: ✅ **ALL METHODS USED - NO ORPHANED CODE**

---

## 🎯 Key Implementation Details

### Audio Playback Flow:
```
User clicks Play
↓
Check if _isPlaying
↓
YES: Pause → _audioPlayer.pause()
NO: Play → _audioPlayer.setSource() → _audioPlayer.resume()
↓
Listeners update state:
├─ onPlayerStateChanged → _isPlaying
├─ onDurationChanged → _duration
├─ onPositionChanged → _position
└─ onPlayerComplete → reset and pause
```

### Page Navigation Flow:
```
Dashboard
├─ Buku Ende → bem_page → bem_detail_page (audio: MP4/MIDI)
├─ Doa-Doa → doa_gabungan_page (3 tabs: doa bapa, pengakuan, dosa)
└─ NRM → nrm_page → nrm_detail_page (PDF viewer + audio: MP3/MIDI)
```

### State Persistence:
```
SharedPreferences
├─ bookmark_nrm_$index → bookmark per halaman NRM
├─ last_read_nrm → terakhir dibaca halaman
└─ (untuk future: bookmark BEM, font size preferences, dll)
```

---

## ✅ Final Verification Checklist

- ✅ Semua methods defined dan implemented
- ✅ Semua methods dipanggil dengan parameter yang benar
- ✅ Tidak ada undefined references
- ✅ Tidak ada type mismatches
- ✅ Semua async operations dengan mounted checks
- ✅ Lifecycle management proper (initState, dispose)
- ✅ State management clean
- ✅ No compilation errors in any file
- ✅ All imports correct and present
- ✅ Navigation paths verified

**RESULT**: 🟢 **PRODUCTION READY**
