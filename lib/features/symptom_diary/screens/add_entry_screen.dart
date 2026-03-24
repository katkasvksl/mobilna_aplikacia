import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/symptom_entry.dart';
import '../../dashboard/providers/symptoms_provider.dart';

class AddEntryScreen extends ConsumerStatefulWidget {
  final String? initialNote;

  const AddEntryScreen({super.key, this.initialNote});

  @override
  ConsumerState<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends ConsumerState<AddEntryScreen> {
  int _overallRating = 3;
  final Set<String> _selectedSymptoms = {};
  TimeOfDay _selectedTime = TimeOfDay.now();
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nový záznam'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall rating
            Text(
              'Celkové hodnotenie dňa',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _overallRating = starIndex),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            starIndex <= _overallRating ? Icons.star : Icons.star_border,
                            color: starIndex <= _overallRating
                                ? AppColors.riskMedium
                                : AppColors.textSecondary,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _ratingLabel(_overallRating),
                    style: TextStyle(
                      color: _ratingColor(_overallRating),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Symptoms
            Text(
              'Symptómy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SymptomEntry.symptomLabels.entries.map((entry) {
                final isSelected = _selectedSymptoms.contains(entry.key);
                return FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(entry.key);
                      } else {
                        _selectedSymptoms.remove(entry.key);
                      }
                    });
                  },
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Time picker
            Text(
              'Čas výskytu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            Text(
              'Poznámky',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Čo ste jedli? Ako ste sa cítili?',
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Uložiť záznam'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _saveEntry() async {
    final now = DateTime.now();
    final timestamp = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final entry = SymptomEntry(
      id: const Uuid().v4(),
      timestamp: timestamp,
      overallRating: _overallRating,
      symptoms: _selectedSymptoms.toList(),
      notes: _notesController.text,
    );

    await StorageService.saveSymptomEntry(entry);
    
    // Refresh the provider to update charts
    ref.read(symptomsProvider.notifier).refresh();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Záznam uložený'),
          backgroundColor: AppColors.riskLow,
        ),
      );
      context.pop();
    }
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Veľmi zlý deň';
      case 2:
        return 'Zlý deň';
      case 3:
        return 'Priemerný deň';
      case 4:
        return 'Dobrý deň';
      case 5:
        return 'Výborný deň';
      default:
        return '';
    }
  }

  Color _ratingColor(int rating) {
    if (rating >= 4) return AppColors.riskLow;
    if (rating >= 3) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }
}
