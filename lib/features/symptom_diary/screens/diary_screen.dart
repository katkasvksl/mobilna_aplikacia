import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/symptom_entry.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _selectedTab = 0; // 0=zoznam, 1=grafy

  @override
  Widget build(BuildContext context) {
    final entries = StorageService.getAllSymptomEntries();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Denník symptómov',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  IconButton(
                    onPressed: () async {
                      await context.push('/add-symptom');
                      setState(() {}); // Refresh after adding
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _tabButton('Záznamy', 0),
                  const SizedBox(width: 12),
                  _tabButton('Grafy', 1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedTab == 0
                  ? _buildEntryList(entries)
                  : _buildCharts(entries),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: AppColors.divider),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEntryList(List<SymptomEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            const Text('Zatiaľ žiadne záznamy'),
            const SizedBox(height: 8),
            const Text(
              'Pridajte prvý záznam stlačením +',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _entryCard(context, entry);
      },
    );
  }

  Widget _entryCard(BuildContext context, SymptomEntry entry) {
    final ratingColor = entry.overallRating >= 4
        ? AppColors.riskLow
        : entry.overallRating >= 2
            ? AppColors.riskMedium
            : AppColors.riskHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(entry.timestamp),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // Star rating
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < entry.overallRating ? Icons.star : Icons.star_border,
                    color: ratingColor,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          if (entry.symptoms.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: entry.symptoms.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.riskHigh.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    SymptomEntry.symptomLabels[s] ?? s,
                    style: const TextStyle(fontSize: 12, color: AppColors.riskHigh),
                  ),
                );
              }).toList(),
            ),
          ],
          if (entry.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              entry.notes,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCharts(List<SymptomEntry> entries) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Týždenný prehľad',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Po', 'Ut', 'St', 'Št', 'Pi', 'So', 'Ne'];
                        final i = value.toInt();
                        if (i >= 0 && i < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[i],
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                maxY: 5,
                barGroups: List.generate(7, (i) {
                  final mockValues = [3.5, 4.0, 2.5, 3.0, 4.5, 3.8, 4.2];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: mockValues[i],
                        color: mockValues[i] >= 4
                            ? AppColors.riskLow
                            : mockValues[i] >= 2.5
                                ? AppColors.riskMedium
                                : AppColors.riskHigh,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Symptom frequency
          Text(
            'Najčastejšie symptómy',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ..._getSymptomFrequency(entries).entries.map((e) {
            return _symptomBar(e.key, e.value, entries.length);
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Map<String, int> _getSymptomFrequency(List<SymptomEntry> entries) {
    final freq = <String, int>{};
    for (final entry in entries) {
      for (final symptom in entry.symptoms) {
        freq[symptom] = (freq[symptom] ?? 0) + 1;
      }
    }
    // Sort by frequency
    final sorted = Map.fromEntries(
      freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  Widget _symptomBar(String symptom, int count, int total) {
    final label = SymptomEntry.symptomLabels[symptom] ?? symptom;
    final ratio = total > 0 ? count / total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.riskHigh),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('$count×', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

