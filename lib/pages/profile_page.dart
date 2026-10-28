import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/models.dart';
import 'edit_profile_page.dart';
import 'project_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile _profile = defaultProfile;

  void _openProjectDetail(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailPage(project: project),
      ),
    );
  }

  Future<void> _openEditProfile() async {
    // await = tunggu sampai halaman Edit ditutup
    final result = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(profile: _profile),
      ),
    );

    // Dua pengaman: widget masih aktif? ada hasil (tidak dibatalkan)?
    if (!mounted || result == null) return;
    setState(() => _profile = result);
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
