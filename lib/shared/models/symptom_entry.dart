class SymptomEntry {
  final String id;
  final DateTime timestamp;
  final int overallRating; // 0–5
  final List<String> symptoms; // ['heartburn', 'cough', 'acidity', 'chest_pressure']
  final String notes;

  const SymptomEntry({
    required this.id,
    required this.timestamp,
    required this.overallRating,
    required this.symptoms,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'overallRating': overallRating,
        'symptoms': symptoms,
        'notes': notes,
      };

  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    return SymptomEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      overallRating: json['overallRating'] as int,
      symptoms: (json['symptoms'] as List<dynamic>).map((e) => e as String).toList(),
      notes: json['notes'] as String,
    );
  }

  static const Map<String, String> symptomLabels = {
    'heartburn': 'Pálenie záhy',
    'cough': 'Kašeľ',
    'acidity': 'Kyslosť',
    'chest_pressure': 'Tlak na hrudi',
    'bloating': 'Nadúvanie',
    'nausea': 'Nevoľnosť',
    'sore_throat': 'Bolesť hrdla',
    'hoarseness': 'Chrapot',
    'difficulty_swallowing': 'Ťažkosti s prehĺtaním',
    'regurgitation': 'Regurgitácia',
  };
}

