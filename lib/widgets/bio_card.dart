import 'package:flutter/material.dart';

class BioCard extends StatelessWidget {
  const BioCard({
    super.key,
    required this.bio,
    required this.isExpanded,
    required this.onTap,
  });

  final String bio;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tentang', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                bio,
                maxLines: isExpanded ? null : 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                isExpanded ? 'Tutup' : 'Selengkapnya',
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
