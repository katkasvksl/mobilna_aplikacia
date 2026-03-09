class Ingredient {
  final String name;
  final double phValue;
  final String fatLevel; // 'low' | 'medium' | 'high'
  final double sugarContent;
  final double fiberContent;

  const Ingredient({
    required this.name,
    required this.phValue,
    required this.fatLevel,
    required this.sugarContent,
    required this.fiberContent,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      phValue: (json['ph_value'] as num).toDouble(),
      fatLevel: json['fat_level'] as String,
      sugarContent: (json['sugar_content'] as num).toDouble(),
      fiberContent: (json['fiber_content'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'ph_value': phValue,
        'fat_level': fatLevel,
        'sugar_content': sugarContent,
        'fiber_content': fiberContent,
      };
}

class FoodItem {
  final String id;
  final String name;
  final String imageUrl;
  final double phValue;
  final String fatLevel; // 'low' | 'medium' | 'high'
  final String overallAcidity; // 'low' | 'medium' | 'high'
  final String refluxRisk; // 'low' | 'medium' | 'high'
  final String category; // 'breakfast' | 'lunch' | 'dinner' | 'snack'
  final int prepTimeMinutes;
  final String difficulty; // 'easy' | 'medium' | 'hard'
  final List<Ingredient> ingredients;
  final List<String> recipeSteps;
  final String? refluxRiskExplanation;

  const FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.phValue,
    required this.fatLevel,
    required this.overallAcidity,
    required this.refluxRisk,
    required this.category,
    required this.prepTimeMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.recipeSteps,
    this.refluxRiskExplanation,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['dish_name'] as String? ?? json['name'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      phValue: (json['ph_value'] as num?)?.toDouble() ?? 7.0,
      fatLevel: json['overall_fat'] as String? ?? json['fatLevel'] as String? ?? 'low',
      overallAcidity: json['overall_acidity'] as String? ?? 'low',
      refluxRisk: json['reflux_risk'] as String? ?? 'low',
      category: json['category'] as String? ?? 'lunch',
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 30,
      difficulty: json['difficulty'] as String? ?? 'easy',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recipeSteps: (json['recipeSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      refluxRiskExplanation: json['reflux_risk_explanation'] as String?,
    );
  }
}

