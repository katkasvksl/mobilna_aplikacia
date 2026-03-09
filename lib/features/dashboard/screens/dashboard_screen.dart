import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/reflux_data.dart';
import '../widgets/daily_meal_carousel.dart';
import '../widgets/reflux_diary_card.dart';
import '../widgets/weekly_trend_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final name = (profile?.name.isNotEmpty ?? false) ? profile!.name : 'Používateľ';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.1),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: AppColors.accent,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ahoj, $name 👋',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Dnes je skvelý deň na zdravé jedlo!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Notification icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Daily meal carousel
              DailyMealCarousel(
                meals: RefluxData.getRecommendedMeals(),
                onMealTap: (food) {
                  context.push('/meal-detail/${food.id}');
                },
              ),
              const SizedBox(height: 24),

              // Reflux diary card
              RefluxDiaryCard(
                onAddEntry: () {
                  context.push('/add-symptom');
                },
              ),
              const SizedBox(height: 24),

              // Weekly trend chart
              const WeeklyTrendChart(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

