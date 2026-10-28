import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Profil Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _name = 'Fakhry Firdaus';
  static const _bio =
      'Mahasiswa Teknik Informatika yang sedang belajar Flutter. '
      'Suka membangun aplikasi mobile yang sederhana, rapi, dan berguna. '
      'Sedang mengerjakan proyek akhir semester bertema kartu profil digital.';

  bool _isFollowing = false;
  int _followers = 1200;
  bool _isBioExpanded = false;

  /// Mengatur status ikuti ke nilai tertentu (bukan sekadar toggle).
  void _setFollowing(bool value) {
    if (_isFollowing == value) return; // tidak ada perubahan, abaikan
    setState(() {
      _isFollowing = value;
      _followers += value ? 1 : -1;
    });
  }

  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar() // hindari Snackbar menumpuk
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false; // null = dialog ditutup dengan tap di luar
  }

  Future<void> _onFollowPressed() async {
    if (!_isFollowing) {
      _setFollowing(true);
      _showSnack(
        'Kamu mulai mengikuti $_name',
        action: SnackBarAction(
          label: 'BATAL',
          onPressed: () => _setFollowing(false),
        ),
      );
      return;
    }

    final confirmed = await _showConfirmDialog(
      title: 'Berhenti mengikuti?',
      message: 'Kamu tidak akan lagi melihat pembaruan dari $_name.',
      confirmLabel: 'Berhenti',
    );

    if (!confirmed || !mounted) return; // wajib dicek setelah await

    _setFollowing(false);
    _showSnack('Kamu berhenti mengikuti $_name');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kartu Profil Digital')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage:
                    NetworkImage('https://picsum.photos/seed/profile/300/300'),
              ),
            ),
            const SizedBox(height: 12),
            Text(_name,
                textAlign: TextAlign.center, style: textTheme.headlineSmall),
            const Text('Mahasiswa', textAlign: TextAlign.center),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}

/// Widget kecil untuk satu angka statistik. Sengaja dibuat StatelessWidget:
/// ia hanya menampilkan data yang diberikan, tidak menyimpan state sendiri.
class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: textTheme.titleLarge),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
