class UserProfile {
  final String name;
  final String avatarPath;
  final String refluxType; // 'GERD' | 'LPR' | 'other'
  final int symptomFrequency; // 1–7 days/week
  final List<String> triggers;
  final List<String> allergies;
  final List<String> goals;
  final bool onboardingCompleted;

  const UserProfile({
    required this.name,
    this.avatarPath = '',
    required this.refluxType,
    this.symptomFrequency = 3,
    required this.triggers,
    required this.allergies,
    required this.goals,
    this.onboardingCompleted = false,
  });

  UserProfile copyWith({
    String? name,
    String? avatarPath,
    String? refluxType,
    int? symptomFrequency,
    List<String>? triggers,
    List<String>? allergies,
    List<String>? goals,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      refluxType: refluxType ?? this.refluxType,
      symptomFrequency: symptomFrequency ?? this.symptomFrequency,
      triggers: triggers ?? this.triggers,
      allergies: allergies ?? this.allergies,
      goals: goals ?? this.goals,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarPath': avatarPath,
        'refluxType': refluxType,
        'symptomFrequency': symptomFrequency,
        'triggers': triggers,
        'allergies': allergies,
        'goals': goals,
        'onboardingCompleted': onboardingCompleted,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      avatarPath: json['avatarPath'] as String? ?? '',
      refluxType: json['refluxType'] as String? ?? 'GERD',
      symptomFrequency: json['symptomFrequency'] as int? ?? 3,
      triggers: (json['triggers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      goals: (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }

  factory UserProfile.empty() => const UserProfile(
        name: '',
        refluxType: 'GERD',
        triggers: [],
        allergies: [],
        goals: [],
      );

  static const Map<String, String> triggerLabels = {
    'acidic': 'Kyslé',
    'fatty': 'Mastné',
    'spicy': 'Pikantné',
    'caffeine': 'Kofeín',
    'alcohol': 'Alkohol',
    'chocolate': 'Čokoláda',
    'citrus': 'Citrusy',
    'tomatoes': 'Paradajky',
    'onions': 'Cibuľa',
    'garlic': 'Cesnak',
    'carbonated': 'Sýtené nápoje',
    'mint': 'Mäta',
  };

  static const Map<String, String> goalLabels = {
    'improve_symptoms': 'Zlepšenie symptómov',
    'adjust_diet': 'Úprava stravy',
    'better_sleep': 'Lepší spánok',
    'weight_loss': 'Zníženie hmotnosti',
    'reduce_medication': 'Zníženie liekov',
  };

  static const Map<String, String> allergyLabels = {
    'gluten': 'Lepok',
    'lactose': 'Laktóza',
    'nuts': 'Orechy',
    'eggs': 'Vajcia',
    'soy': 'Sója',
    'fish': 'Ryby',
    'shellfish': 'Kôrovce',
  };
}

