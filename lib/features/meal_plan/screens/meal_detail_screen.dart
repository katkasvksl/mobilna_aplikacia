import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/reflux_data.dart';
import '../../../shared/models/food_item.dart';
import '../../../shared/widgets/risk_indicator_circle.dart';
import '../../../shared/utils/number_formatting.dart';

class MealDetailScreen extends StatefulWidget {
  final String foodId;

  const MealDetailScreen({super.key, required this.foodId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = RefluxData.getFoodById(widget.foodId);
    if (food == null) {
      return Scaffold(
        body: Center(child: Text('Jedlo nenájdené')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Hero Image
          _buildHeroImage(context, food),
          // Tab bar
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Prehľad'),
                Tab(text: 'Recept'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, food),
                _buildRecipeTab(context, food),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, FoodItem food) {
    final height = MediaQuery.of(context).size.height * 0.38;

    return Stack(
      children: [
        Hero(
          tag: 'food_${food.id}',
          child: Container(
            height: height,
            width: double.infinity,
            color: AppColors.background,
            child: food.imageUrl.isNotEmpty
                ? food.imageUrl.startsWith('http')
                    ? Image.network(
                        food.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, st) => _imagePlaceholder(),
                      )
                    : Image.asset(
                        food.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, st) => _imagePlaceholder(),
                      )
                : _imagePlaceholder(),
          ),
        ),
        // Top bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
              _circleButton(
                icon: Icons.more_vert,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(
        Icons.restaurant,
        size: 60,
        color: AppColors.textSecondary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, FoodItem food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips
          Row(
            children: [
              _chip('⏱ ${food.prepTimeMinutes} min'),
              const SizedBox(width: 8),
              _chip(AppColors.difficultyLabel(food.difficulty)),
            ],
          ),
          const SizedBox(height: 12),
          // Name
          Text(
            food.name,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          if (food.refluxRiskExplanation != null) ...[
            Text(
              food.refluxRiskExplanation!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
          ],
          // 3 metric indicators
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: AppTheme.cardDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RiskIndicatorCircle(
                  label: 'Kyslosť (pH)',
                  value: AppColors.riskLabel(food.overallAcidity),
                  level: food.overallAcidity,
                ),
                RiskIndicatorCircle(
                  label: 'Tuky',
                  value: AppColors.fatLabel(food.fatLevel),
                  level: food.fatLevel,
                ),
                RiskIndicatorCircle(
                  label: 'Riziko refluxu',
                  value: AppColors.riskLabel(food.refluxRisk),
                  level: food.refluxRisk,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Ingredients
          Text(
            'Ingrediencie',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ...food.ingredients.map((ing) => _buildIngredientRow(context, ing)),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _buildIngredientRow(BuildContext context, Ingredient ingredient) {
    final phColor = ingredient.phValue >= 6.0
        ? AppColors.riskLow
        : ingredient.phValue >= 4.5
            ? AppColors.riskMedium
            : AppColors.riskHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          // pH color indicator
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: phColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _metricChip('pH ~${formatMax2Decimals(ingredient.phValue)}', phColor),
                    const SizedBox(width: 6),
                    _metricChip('Tuk: ${AppColors.fatLabel(ingredient.fatLevel)}',
                        AppColors.riskColor(ingredient.fatLevel)),
                    const SizedBox(width: 6),
                    _metricChip('Cukor: ${formatMax2Decimals(ingredient.sugarContent)}g',
                        AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildRecipeTab(BuildContext context, FoodItem food) {
    if (food.recipeSteps.isEmpty) {
      return const Center(
        child: Text('Recept nie je k dispozícii'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Postup prípravy',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...food.recipeSteps.asMap().entries.map((entry) {
            final step = entry.key + 1;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Text(
                        '$step',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

