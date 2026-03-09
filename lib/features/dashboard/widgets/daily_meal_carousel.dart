import 'package:flutter/material.dart';
import '../../../core/constants/reflux_data.dart';
import '../../../shared/models/food_item.dart';
import '../../../shared/widgets/food_card.dart';

class DailyMealCarousel extends StatelessWidget {
  final List<FoodItem> meals;
  final void Function(FoodItem) onMealTap;

  const DailyMealCarousel({
    super.key,
    required this.meals,
    required this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayMeals = meals.isNotEmpty ? meals : RefluxData.getRecommendedMeals();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Odporúčané jedlá na dnes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: displayMeals.length,
            itemBuilder: (context, index) {
              return DashboardFoodCard(
                food: displayMeals[index],
                onTap: () => onMealTap(displayMeals[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

