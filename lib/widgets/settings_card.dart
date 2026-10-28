import 'package:flutter/material.dart';
import '../models/profile_status.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.openToWork,
    required this.onOpenToWorkChanged,
    required this.allSkills,
    required this.selectedSkills,
    required this.onSkillChanged,
    required this.status,
    required this.onStatusChanged,
    required this.onReset,
  });

  final bool openToWork;
  final ValueChanged<bool> onOpenToWorkChanged;
  final List<String> allSkills;
  final Set<String> selectedSkills;
  final void Function(String skill, bool selected) onSkillChanged;
  final ProfileStatus status;
  final ValueChanged<ProfileStatus> onStatusChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pengaturan Profil', style: textTheme.titleMedium),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Open to Work'),
              subtitle: const Text('Tampilkan lencana di kartu profilmu'),
              value: openToWork,
              onChanged: onOpenToWorkChanged,
            ),
            const Divider(),
            const Text('Keahlian'),
            for (final skill in allSkills)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(skill),
                value: selectedSkills.contains(skill),
                onChanged: (value) => onSkillChanged(skill, value ?? false),
              ),
            const Divider(),
            const Text('Status'),
            DropdownButton<ProfileStatus>(
              isExpanded: true,
              value: status,
              items: [
                for (final s in ProfileStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (value) {
                if (value != null) onStatusChanged(value);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset pengaturan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
