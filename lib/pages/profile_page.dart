import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../data/dummy_data.dart';
import '../models/models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _profile = defaultProfile;

  void _openProjectDetail(Project project) {
    Navigator.pushNamed(
      context,
      AppRoutes.projectDetail,
      arguments: project, // dikirim sebagai arguments
    );
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editProfile,
      arguments: _profile,
    );

    // `is Profile` = cek tipe sekaligus cek null
    if (!mounted || result is! Profile) return;
    setState(() => _profile = result);
  }

  void _logout() {
    // Pindah ke Splash DAN hapus semua halaman di bawahnya
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.splash,
      (route) => false, // false = hapus semua route lama
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil Digital'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit profil',
            onPressed: _openEditProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage:
                  NetworkImage('https://picsum.photos/seed/profile/300/300'),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _profile.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(_profile.bio, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text('Proyek', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final project in dummyProjects)
            Card(
              child: ListTile(
                leading: const Icon(Icons.folder_open),
                title: Text(project.title),
                subtitle: Text(project.techStack.join(' • ')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openProjectDetail(project),
              ),
            ),
        ],
      ),
    );
  }
}
