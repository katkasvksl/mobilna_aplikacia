import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/symptom_entry.dart';
import '../../shared/models/user_profile.dart';

class StorageService {
  static const String _userProfileBox = 'user_profile';
  static const String _symptomEntriesBox = 'symptom_entries';
  static const String _settingsBox = 'settings';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(_userProfileBox);
    await Hive.openBox(_symptomEntriesBox);
    await Hive.openBox(_settingsBox);
  }

  // User Profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    final box = Hive.box(_userProfileBox);
    await box.put('profile', jsonEncode(profile.toJson()));
  }

  static UserProfile? getUserProfile() {
    final box = Hive.box(_userProfileBox);
    final data = box.get('profile');
    if (data != null) {
      return UserProfile.fromJson(jsonDecode(data as String));
    }
    return null;
  }

  static bool isOnboardingCompleted() {
    final profile = getUserProfile();
    return profile?.onboardingCompleted ?? false;
  }

  // Symptom Entries
  static Future<void> saveSymptomEntry(SymptomEntry entry) async {
    final box = Hive.box(_symptomEntriesBox);
    await box.put(entry.id, jsonEncode(entry.toJson()));
  }

  static Future<void> deleteSymptomEntry(String id) async {
    final box = Hive.box(_symptomEntriesBox);
    await box.delete(id);
  }

  static List<SymptomEntry> getAllSymptomEntries() {
    final box = Hive.box(_symptomEntriesBox);
    final entries = <SymptomEntry>[];
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        entries.add(SymptomEntry.fromJson(jsonDecode(data as String)));
      }
    }
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  static List<SymptomEntry> getSymptomEntriesForDate(DateTime date) {
    return getAllSymptomEntries().where((e) {
      return e.timestamp.year == date.year &&
          e.timestamp.month == date.month &&
          e.timestamp.day == date.day;
    }).toList();
  }

  static List<SymptomEntry> getSymptomEntriesForWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return getAllSymptomEntries().where((e) {
      return e.timestamp.isAfter(startOfWeek) && e.timestamp.isBefore(endOfWeek);
    }).toList();
  }

  static SymptomEntry? getLastSymptomEntry() {
    final entries = getAllSymptomEntries();
    return entries.isNotEmpty ? entries.first : null;
  }

  // Settings
  static Future<void> setSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue);
  }
}

