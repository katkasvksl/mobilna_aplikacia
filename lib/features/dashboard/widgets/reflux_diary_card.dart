import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/symptom_entry.dart';

class RefluxDiaryCard extends StatelessWidget {
  final VoidCallback onAddEntry;

  const RefluxDiaryCard({
    super.key,
    required this.onAddEntry,
  });

  @override
  Widget build(BuildContext context) {
    final lastEntry = StorageService.getLastSymptomEntry();
    final statusInfo = _getStatusInfo(lastEntry);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Denník refluxu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Circular indicator
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusInfo.color.withValues(alpha: 0.12),
                  ),
                  child: Center(
                    child: Icon(
                      statusInfo.icon,
                      color: statusInfo.color,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktuálny stav: ${statusInfo.label}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: statusInfo.color,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastEntry != null
                            ? 'Posledný záznam: ${_formatDate(lastEntry.timestamp)}'
                            : 'Zatiaľ žiadny záznam',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddEntry,
                child: const Text('Pridať záznam'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo(SymptomEntry? entry) {
    if (entry == null) {
      return _StatusInfo(
        label: 'Žiadne dáta',
        color: AppColors.textSecondary,
        icon: Icons.help_outline,
      );
    }
    if (entry.overallRating >= 4) {
      return _StatusInfo(
        label: 'Dobrý',
        color: AppColors.riskLow,
        icon: Icons.sentiment_satisfied_alt,
      );
    } else if (entry.overallRating >= 2) {
      return _StatusInfo(
        label: 'Priemerný',
        color: AppColors.riskMedium,
        icon: Icons.sentiment_neutral,
      );
    } else {
      return _StatusInfo(
        label: 'Zlý',
        color: AppColors.riskHigh,
        icon: Icons.sentiment_dissatisfied,
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return 'Dnes o ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Včera o ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  _StatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });
}

