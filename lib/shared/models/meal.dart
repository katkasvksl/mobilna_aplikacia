class Meal {
  final String id;
  final String foodItemId;
  final DateTime date;
  final String mealType; // 'breakfast' | 'lunch' | 'dinner' | 'snack'

  const Meal({
    required this.id,
    required this.foodItemId,
    required this.date,
    required this.mealType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodItemId': foodItemId,
        'date': date.toIso8601String(),
        'mealType': mealType,
      };

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      foodItemId: json['foodItemId'] as String,
      date: DateTime.parse(json['date'] as String),
      mealType: json['mealType'] as String,
    );
  }
}

