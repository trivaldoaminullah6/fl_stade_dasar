import 'package:flutter/material.dart';
import '../models/profile_status.dart';
import '../widgets/bio_card.dart';
import '../widgets/settings_card.dart';
import '../widgets/skills_card.dart';
import '../widgets/stat_item.dart';

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
  static const _allSkills = ['Flutter', 'Dart', 'UI/UX', 'Firebase', 'Git'];

  bool _isFollowing = false;
  int _followers = 1200;
  bool _isBioExpanded = false;
  bool _openToWork = false;
  final Set<String> _skills = {'Flutter'};
  ProfileStatus _status = ProfileStatus.student;

  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
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
    return result ?? false;
  }

  void _setFollowing(bool value) {
    if (_isFollowing == value) return;
    setState(() {
      _isFollowing = value;
      _followers += value ? 1 : -1;
    });
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

    if (!confirmed || !mounted) return;

    _setFollowing(false);
    _showSnack('Kamu berhenti mengikuti $_name');
  }

  void _onSkillChanged(String skill, bool selected) {
    setState(() {
      if (selected) {
        _skills.add(skill);
      } else {
        _skills.remove(skill);
      }
    });
  }

  Future<void> _onResetPressed() async {
    final confirmed = await _showConfirmDialog(
      title: 'Reset pengaturan?',
      message: 'Semua pengaturan akan kembali ke nilai awal.',
      confirmLabel: 'Reset',
    );
    if (!confirmed || !mounted) return;

    setState(() {
      _openToWork = false;
      _skills
        ..clear()
        ..add('Flutter');
      _status = ProfileStatus.student;
    });
    _showSnack('Pengaturan berhasil direset');
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
            Text(_status.label, textAlign: TextAlign.center),
            if (_openToWork) ...[
              const SizedBox(height: 8),
              const Center(
                child: Chip(
                  avatar: Icon(Icons.work_outline, size: 18),
                  label: Text('Open to Work'),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const StatItem(label: 'Postingan', value: '48'),
                    StatItem(label: 'Pengikut', value: '$_followers'),
                    const StatItem(label: 'Mengikuti', value: '320'),
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
            BioCard(
              bio: _bio,
              isExpanded: _isBioExpanded,
              onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
            ),
            const SizedBox(height: 16),
            SkillsCard(skills: _skills),
            const SizedBox(height: 16),
            SettingsCard(
              openToWork: _openToWork,
              onOpenToWorkChanged: (value) =>
                  setState(() => _openToWork = value),
              allSkills: _allSkills,
              selectedSkills: _skills,
              onSkillChanged: _onSkillChanged,
              status: _status,
              onStatusChanged: (value) => setState(() => _status = value),
              onReset: _onResetPressed,
            ),
          ],
        ),
      ),
    );
  }
}
