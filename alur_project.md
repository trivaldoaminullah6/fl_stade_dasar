# Alur Pembelajaran Project: Kartu Profil Digital

Dokumen ini mencatat setiap langkah perubahan kode, lokasi file, nomor baris, dan penjelasannya sebagai media pembelajaran.

---

## Modul 1: Fondasi State, Event, dan Callback

### 1. Rangkuman Konsep Teori
* **State**: Data dinamis yang memengaruhi UI (`UI = f(state)`).
* **Event**: Aksi dari pengguna (misal tap, switch, swipe).
* **Callback**: Fungsi yang dijalankan saat event terjadi (misal `onPressed`, `onTap`).
* **setState()**: Memberitahu Flutter bahwa state berubah agar fungsi `build()` dijalankan ulang.
* **Jenis State**:
  * *Ephemeral State*: State lokal satu widget (dikelola via `setState()`).
  * *App State*: State global lintas halaman (misal via Provider/Bloc/Riverpod).

---

## Modul 2: Persiapan Starter Code (Kartu Profil Digital)

Pada tahap ini, template default Flutter (`counter app`) diganti menjadi struktur dasar aplikasi Kartu Profil Digital.

### Daftar File yang Diubah

#### 1. `android/app/src/main/AndroidManifest.xml`
* **Lokasi Perubahan**: Baris 2
* **Kode**:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  ```
* **Alasan**: Diperlukan agar aplikasi Android memiliki izin akses internet untuk memuat gambar avatar dari URL network (`https://picsum.photos/...`).

---

#### 2. `lib/main.dart`
Struktur lengkap file starter code:

| Rentang Baris | Komponen / Bagian | Fungsi & Penjelasan |
| :--- | :--- | :--- |
| **Baris 1 - 3** | `import` & `main()` | Titik masuk aplikasi Flutter, memanggil `runApp(const MyApp())`. |
| **Baris 5 - 17** | `class MyApp` (`StatelessWidget`) | Root widget aplikasi yang mengonfigurasi `MaterialApp`, judul, tema (`colorSchemeSeed: Colors.indigo`), dan menetapkan `home: const ProfilePage()`. |
| **Baris 19 - 24** | `class ProfilePage` (`StatefulWidget`) | Widget utama profil. Dibuat `StatefulWidget` karena nantinya akan memiliki state dinamis (mengikuti/tidak mengikuti, jumlah pengikut). |
| **Baris 26 - 32** | `class _ProfilePageState` & Variabel Awal | Class state penyimpan data: mendefinisikan variabel statis `_name` dan `_bio` di luar method `build()`. |
| **Baris 34 - 39** | `build()` & `Scaffold` | Merender kerangka layar dengan `AppBar` dan konten yang dibungkus `SingleChildScrollView` (agar tidak overflow saat keyboard muncul atau layar kecil). |
| **Baris 44 - 50** | `CircleAvatar` | Menampilkan foto profil bulat dari URL `NetworkImage('https://picsum.photos/seed/profile/300/300')`. |
| **Baris 52 - 54** | `Text` Nama & Profesi | Menampilkan nama profil dan label pekerjaan. |
| **Baris 56 - 68** | `Card` Statistik | Menampilkan baris statistik profil (Postingan, Pengikut, Mengikuti) menggunakan widget reusable `_StatItem`. |
| **Baris 70 - 74** | `FilledButton.icon` (Tombol Ikuti) | Tombol aksi utama dengan event `onPressed: () {}`. Pada tahap starter ini callback masih kosong. |
| **Baris 76 - 88** | `Card` Tentang | Kartu ringkasan bio profil pengguna. |
| **Baris 98 - 115** | `class _StatItem` (`StatelessWidget`) | Widget reusable kecil khusus untuk menampilkan angka statistik beserta labelnya (tidak memiliki internal state). |

---

### Checkpoint Verifikasi
1. Jalankan aplikasi via `flutter run`.
2. UI Kartu Profil Digital tampil lengkap (foto profil, nama, statistik angka, tombol Ikuti, dan kartu Tentang).
3. Tombol Ikuti ditekan belum memberikan respons apa pun karena callback `onPressed` belum memiliki logika `setState()`.

---

## Modul 3: Toggle Tombol Ikuti ⇄ Mengikuti dengan `setState()`

**Target**: Tombol "Ikuti" berubah menjadi "Mengikuti" (dan sebaliknya) saat ditekan.

### Perubahan Kode di `lib/main.dart`

#### 1. Deklarasi State Variable
* **Lokasi**: Baris 33
* **Kode**:
  ```dart
  bool _isFollowing = false;
  ```
* **Penjelasan**: Menampung status apakah pengguna sedang mengikuti profil ini. Diletakkan di dalam class `_ProfilePageState` (di luar method `build`) agar nilainya persisten dan tidak ter-reset saat widget dirender ulang.

#### 2. Event Handler Callback dengan `setState()`
* **Lokasi**: Baris 35 - 39
* **Kode**:
  ```dart
  void _onFollowPressed() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }
  ```
* **Penjelasan**:
  * Menggunakan method terpisah bernama `_onFollowPressed` (sesuai best practice penamaan handler `_on...`).
  * `!_isFollowing` membalik nilai boolean (`false` ⇄ `true`).
  * Pembungkus `setState(() { ... })` memberi sinyal ke Flutter engine bahwa state telah berubah, memicu pemanggilan ulang fungsi `build()`.
  * *Catatan Eksperimen*: Tanpa `setState()`, variabel `_isFollowing` tetap berubah di memori, tetapi Flutter tidak akan menggambar ulang UI.

#### 3. Kondisional UI Rendering (Ternary Operator)
* **Lokasi**: Baris 78 - 88
* **Kode**:
  ```dart
  _isFollowing
      ? OutlinedButton.icon(
          onPressed: _onFollowPressed,
          icon: const Icon(Icons.check),
          label: const Text('Mengikuti'),
        )
      : FilledButton.icon(
          onPressed: _onFollowPressed,
          icon: const Icon(Icons.person_add),
          label: const Text('Ikuti'),
        ),
  ```
* **Penjelasan**:
  * Mengimplementasikan prinsip `UI = f(state)`.
  * Saat `_isFollowing == true`: Menampilkan `OutlinedButton` dengan teks "Mengikuti" dan ikon `Icons.check`.
  * Saat `_isFollowing == false`: Menampilkan `FilledButton` dengan teks "Ikuti" dan ikon `Icons.person_add`.

### Checkpoint Verifikasi
1. Lakukan hot reload (`r`).
2. Tekan tombol. Tombol berganti status antara **Ikuti** (FilledButton) dan **Mengikuti** (OutlinedButton) beserta ikonnya secara responsif.

---

## Modul 4: Jumlah Pengikut Dinamis & Idempotent Handler

**Target**: Angka pengikut bertambah (+1) saat tombol "Ikuti" ditekan, dan berkurang (-1) saat status diubah kembali menjadi "Mengikuti".

### Perubahan Kode di `lib/main.dart`

#### 1. Deklarasi State Variable Jumlah Pengikut
* **Lokasi**: Baris 34
* **Kode**:
  ```dart
  int _followers = 1200;
  ```
* **Penjelasan**: Menyimpan angka pengikut awal (1200) sebagai state dinamis.

#### 2. Logika Handler Idempoten (`_setFollowing` & `_onFollowPressed`)
* **Lokasi**: Baris 36 - 47
* **Kode**:
  ```dart
  /// Mengatur status ikuti ke nilai tertentu (bukan sekadar toggle).
  void _setFollowing(bool value) {
    if (_isFollowing == value) return; // tidak ada perubahan, abaikan
    setState(() {
      _isFollowing = value;
      _followers += value ? 1 : -1;
    });
  }

  void _onFollowPressed() {
    _setFollowing(!_isFollowing);
  }
  ```
* **Penjelasan**:
  * **Idempoten**: Method `_setFollowing(bool value)` memeriksa `if (_isFollowing == value) return;`. Jika dipanggil berulang kali dengan parameter yang sama, state tidak akan berubah ganda. Ini mencegah bug race-condition atau klik beruntun cepat.
  * Di dalam `setState()`: Nilai `_followers` dihitung dengan ternary `value ? 1 : -1`.

#### 3. Pembaruan Widget Statistik (Pelepasan `const`)
* **Lokasi**: Baris 72 - 84
* **Kode**:
  ```dart
  Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const _StatItem(label: 'Postingan', value: '48'),
          _StatItem(label: 'Pengikut', value: '$_followers'),
          const _StatItem(label: 'Mengikuti', value: '320'),
        ],
      ),
    ),
  ),
  ```
* **Penjelasan**:
  * Karena `$_followers` bersifat dinamis (runtime value), kata kunci `const` pada `Card` dan `Row` harus dihilangkan. Jika tidak, muncul error `Not a constant expression`.
  * Kata kunci `const` tetap dipertahankan pada item yang statis (`Postingan: 48` dan `Mengikuti: 320`) untuk optimasi performa render Flutter.

### Checkpoint Verifikasi
1. Lakukan hot reload (`r`).
2. Tekan tombol **Ikuti**:
   * Status tombol berubah menjadi **Mengikuti**.
   * Angka pengikut berubah menjadi **1201**.
3. Tekan kembali:
   * Status tombol berubah menjadi **Ikuti**.
   * Angka pengikut kembali ke **1200**.
4. Tekan berulang kali: Nilai selalu konsisten antara 1200 dan 1201 (tidak pernah melompat ke 1202 atau 1199).

---

## Modul 5: Feedback Pengguna — SnackBar & Aksi Undo

**Target**: Memberikan umpan balik instan saat status berubah melalui SnackBar melayang (`floating`) dan menyediakan tombol aksi "BATAL" (*Undo*) untuk membatalkan aksi secara instan.

### Perubahan Kode di `lib/main.dart`

#### 1. Pembuatan Helper Method `_showSnack`
* **Lokasi**: Baris 45 - 55
* **Kode**:
  ```dart
  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // hindari SnackBar menumpuk
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }
  ```
* **Penjelasan**:
  * Menggunakan `ScaffoldMessenger.of(context)` (standar modern Flutter).
  * `..hideCurrentSnackBar()`: Cascade operator untuk menutup SnackBar yang sedang tampil sebelum memunculkan yang baru, mencegah antrean pesan menumpuk saat tombol ditekan cepat.
  * `behavior: SnackBarBehavior.floating`: SnackBar melayang di atas konten, tidak menempel kaku di dasar layar.
  * Menerima opsional parameter `action` bertipe `SnackBarAction?`.

#### 2. Modifikasi `_onFollowPressed` dengan Pesan & Aksi Undo
* **Lokasi**: Baris 57 - 71
* **Kode**:
  ```dart
  void _onFollowPressed() {
    if (_isFollowing) {
      _setFollowing(false);
      _showSnack('Kamu berhenti mengikuti $_name');
    } else {
      _setFollowing(true);
      _showSnack(
        'Kamu mulai mengikuti $_name',
        action: SnackBarAction(
          label: 'BATAL',
          onPressed: () => _setFollowing(false), // Undo
        ),
      );
    }
  }
  ```
* **Penjelasan**:
  * Ketika mulai mengikuti (`_isFollowing == false`): Memanggil `_setFollowing(true)` dan memunculkan SnackBar bertombol `BATAL`.
  * Tombol `BATAL` memanfaatkan sifat idempoten method `_setFollowing(false)` untuk mengembalikan status mengikuti dan mengurangi angka pengikut kembali ke 1200.
  * Ketika berhenti mengikuti: Memanggil `_setFollowing(false)` dengan notifikasi sederhana tanpa tombol undo.

### Checkpoint Verifikasi
1. Lakukan hot reload (`r`).
2. Tekan tombol **Ikuti**:
   * SnackBar melayang muncul dengan pesan: *"Kamu mulai mengikuti Fakhry Firdaus"* dan tombol **BATAL**.
3. Tekan tombol **BATAL** pada SnackBar:
   * Status tombol langsung kembali ke **Ikuti** dan angka pengikut kembali ke **1200**.
4. Tekan tombol **Ikuti** berkali-kali secara cepat:
   * SnackBar tidak menumpuk dalam antrean panjang karena selalu di-reset oleh `hideCurrentSnackBar()`.

---

## Modul 6: Expand/Collapse Bio (Kartu Tentang) dengan `InkWell`

**Target**: Kartu "Tentang" dapat di-tap untuk membuka (expand) seluruh bio atau menutupnya (collapse) menjadi 2 baris dengan animasi efek riak (*ripple*).

### Perubahan Kode di `lib/main.dart`

#### 1. Deklarasi State Variable Expand/Collapse
* **Lokasi**: Baris 35
* **Kode**:
  ```dart
  bool _isBioExpanded = false;
  ```
* **Penjelasan**: Menyimpan status apakah teks bio sedang dalam kondisi terbuka penuh (`true`) atau terpotong (`false`).

#### 2. Pembungkusan Kartu dengan `InkWell` & Dinamika Text
* **Lokasi**: Baris 123 - 149
* **Kode**:
  ```dart
  Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tentang', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              _bio,
              maxLines: _isBioExpanded ? null : 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              _isBioExpanded ? 'Tutup' : 'Selengkapnya',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    ),
  ),
  ```
* **Penjelasan**:
  * **`InkWell` vs `GestureDetector`**: `InkWell` memberikan efek visual riak sentuhan (*Material ripple effect*) saat disentuh serta mendukung `borderRadius` melengkung sesuai lengkungan `Card`. `GestureDetector` mendeteksi sentuhan serupa tetapi tanpa feedback visual ripple.
  * **Callback `onTap`**: Menjalankan inline `setState(() => _isBioExpanded = !_isBioExpanded)` untuk membalik state.
  * **`maxLines`**: Jika `_isBioExpanded == true`, `maxLines` diatur ke `null` (menampilkan seluruh teks tanpa batas). Jika `false`, dibatasi maksimal 2 baris.
  * **`overflow: TextOverflow.ellipsis`**: Menambahkan tanda elipsis titik-titik (`...`) saat teks terpotong di baris ke-2.
  * **Label Dinamis**: Teks berubah antara "Selengkapnya" dan "Tutup" dengan warna aksen tema (`Theme.of(context).colorScheme.primary`).

### Checkpoint Verifikasi
1. Lakukan hot reload (`r`).
2. Tampilan awal: Bio hanya muncul 2 baris berakhiran `...` dengan teks "Selengkapnya".
3. Tap pada kartu Tentang: Muncul efek riak ripple, seluruh teks bio terbuka, dan teks berubah menjadi "Tutup".
4. Tap kembali: Bio menutup kembali menjadi 2 baris.




