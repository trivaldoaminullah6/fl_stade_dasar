import 'package:flutter/material.dart';

class SkillsCard extends StatelessWidget {
  const SkillsCard({
    super.key,
    required this.skills,
  });

  final Set<String> skills;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keahlian', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            if (skills.isEmpty)
              const Text('Belum ada keahlian dipilih')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in skills) Chip(label: Text(s)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
