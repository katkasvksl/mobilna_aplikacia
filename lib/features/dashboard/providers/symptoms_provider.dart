import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/symptom_entry.dart';

final symptomsProvider = StateNotifierProvider<SymptomsNotifier, List<SymptomEntry>>((ref) {
  return SymptomsNotifier();
});

class SymptomsNotifier extends StateNotifier<List<SymptomEntry>> {
  SymptomsNotifier() : super([]) {
    _loadEntries();
  }

  void _loadEntries() {
    state = StorageService.getAllSymptomEntries();
  }

  void refresh() {
    _loadEntries();
  }
}
