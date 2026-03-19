import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/claude_ai_service.dart';
import '../../../shared/models/food_item.dart';
import '../../../shared/widgets/risk_indicator_circle.dart';
import '../../../shared/utils/number_formatting.dart';

class ScanResultScreen extends StatefulWidget {
  final Uint8List? imageBytes;

  const ScanResultScreen({super.key, this.imageBytes});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  bool _isLoading = true;
  FoodItem? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    if (widget.imageBytes == null) {
      setState(() {
        _isLoading = false;
        _error = 'Žiadny obrázok na analýzu';
      });
      return;
    }

    try {
      // NOTE: Replace with your actual API key
      const apiKey = String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
      if (apiKey.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = 'API kľúč nie je nastavený. Nastavte CLAUDE_API_KEY.';
          // Show mock result for demo
          _result = _mockResult();
        });
        return;
      }

      final service = ClaudeAiService(apiKey: apiKey);
      final result = await service.analyzeFoodPhoto(widget.imageBytes!);
      setState(() {
        _isLoading = false;
        _result = result;
      });
    } on AiServiceException catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.message;
        _result = _mockResult();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Chyba: $e';
        _result = _mockResult();
      });
    }
  }

  FoodItem _mockResult() {
    return const FoodItem(
      id: 'scan_demo',
      name: 'Analyzované jedlo (demo)',
      imageUrl: '',
      phValue: 5.8,
      fatLevel: 'medium',
      overallAcidity: 'low',
      refluxRisk: 'medium',
      category: 'lunch',
      prepTimeMinutes: 0,
      difficulty: 'medium',
      ingredients: [
        Ingredient(name: 'Ryža', phValue: 6.0, fatLevel: 'low', sugarContent: 0.1, fiberContent: 0.4),
        Ingredient(name: 'Kuracie mäso', phValue: 6.0, fatLevel: 'low', sugarContent: 0.0, fiberContent: 0.0),
        Ingredient(name: 'Zelenina', phValue: 6.3, fatLevel: 'low', sugarContent: 2.0, fiberContent: 2.5),
      ],
      recipeSteps: [],
      refluxRiskExplanation: 'Toto je demo výsledok. Pre reálnu analýzu nastavte CLAUDE_API_KEY.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Výsledok analýzy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.accent),
                  SizedBox(height: 16),
                  Text('AI analyzuje vaše jedlo...'),
                ],
              ),
            )
          : _buildResult(context),
    );
  }

  Widget _buildResult(BuildContext context) {
    if (_result == null && _error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.riskHigh),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Späť'),
              ),
            ],
          ),
        ),
      );
    }

    final food = _result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show scanned image
          if (widget.imageBytes != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: MemoryImage(widget.imageBytes!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Warning if demo mode
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.riskMedium.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.riskMedium.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.riskMedium, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo režim – $_error',
                      style: const TextStyle(fontSize: 12, color: AppColors.riskMedium),
                    ),
                  ),
                ],
              ),
            ),

          // Name
          Text(food.name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          if (food.refluxRiskExplanation != null)
            Text(food.refluxRiskExplanation!, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          // 3 metric cards
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  context,
                  'Kyslosť',
                  AppColors.riskLabel(food.overallAcidity),
                  food.overallAcidity,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  context,
                  'Tuky',
                  AppColors.fatLabel(food.fatLevel),
                  food.fatLevel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  context,
                  'Riziko',
                  AppColors.riskLabel(food.refluxRisk),
                  food.refluxRisk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Ingredients
          Text('Ingrediencie', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          ...food.ingredients.map((ing) => _ingredientRow(context, ing)),
        ],
      ),
    );
  }

  Widget _metricCard(
    BuildContext context,
    String label,
    String value,
    String level,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: AppTheme.cardDecoration,
      child: RiskIndicatorCircle(
        label: label,
        value: value,
        level: level,
        size: 60,
      ),
    );
  }

  Widget _ingredientRow(BuildContext context, Ingredient ingredient) {
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
                Text(ingredient.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'pH ~${formatMax2Decimals(ingredient.phValue)} · Tuk: ${AppColors.fatLabel(ingredient.fatLevel)} · Cukor: ${formatMax2Decimals(ingredient.sugarContent)}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

