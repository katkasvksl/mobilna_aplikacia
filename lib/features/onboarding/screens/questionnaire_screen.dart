import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/user_profile.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Step 0: Name
  final _nameController = TextEditingController();

  // Step 1: Reflux type
  String _refluxType = 'GERD';

  // Step 2: Symptom frequency
  double _symptomFrequency = 3;

  // Step 3: Triggers
  final Set<String> _selectedTriggers = {};

  // Step 4: Goals + Allergies
  final Set<String> _selectedGoals = {};
  final Set<String> _selectedAllergies = {};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Krok ${_currentStep + 1} z $_totalSteps'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameStep(),
                _buildRefluxTypeStep(),
                _buildFrequencyStep(),
                _buildTriggersStep(),
                _buildGoalsAndAllergiesStep(),
              ],
            ),
          ),
          // Next button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextStep,
                child: Text(
                  _currentStep < _totalSteps - 1 ? 'Pokračovať' : 'Dokončiť',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveProfile() async {
    final profile = UserProfile(
      name: _nameController.text.isNotEmpty ? _nameController.text : 'Používateľ',
      refluxType: _refluxType,
      symptomFrequency: _symptomFrequency.round(),
      triggers: _selectedTriggers.toList(),
      allergies: _selectedAllergies.toList(),
      goals: _selectedGoals.toList(),
      onboardingCompleted: true,
    );

    await StorageService.saveUserProfile(profile);

    if (mounted) {
      context.go('/');
    }
  }

  // Step 0: Name
  Widget _buildNameStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ako sa voláte?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Vaše meno použijeme na personalizáciu aplikácie.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Vaše meno',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }

  // Step 1: Reflux type
  Widget _buildRefluxTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Aký typ refluxu máte?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Pomôže nám to prispôsobiť odporúčania.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _typeCard(
            'GERD',
            'Gastroezofágový reflux',
            'Pálenie záhy, kyslý reflux',
            Icons.local_fire_department,
          ),
          const SizedBox(height: 12),
          _typeCard(
            'LPR',
            'Laryngofaryngálny reflux',
            'Kašeľ, chrapot, bolesť hrdla',
            Icons.record_voice_over,
          ),
          const SizedBox(height: 12),
          _typeCard(
            'other',
            'Iné / Neviem',
            'Nie som si istý/á',
            Icons.help_outline,
          ),
        ],
      ),
    );
  }

  Widget _typeCard(String type, String title, String subtitle, IconData icon) {
    final isSelected = _refluxType == type;
    return GestureDetector(
      onTap: () => setState(() => _refluxType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : AppColors.background,
              ),
              child: Icon(icon, color: isSelected ? AppColors.accent : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent, size: 24),
          ],
        ),
      ),
    );
  }

  // Step 2: Frequency slider
  Widget _buildFrequencyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ako často máte symptómy?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Koľko dní v týždni pociťujete problémy?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          Center(
            child: Text(
              '${_symptomFrequency.round()}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 72,
                    color: _symptomFrequency <= 2
                        ? AppColors.riskLow
                        : _symptomFrequency <= 4
                            ? AppColors.riskMedium
                            : AppColors.riskHigh,
                  ),
            ),
          ),
          Center(
            child: Text(
              'dní v týždni',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 32),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: AppColors.divider,
              thumbColor: AppColors.accent,
              overlayColor: AppColors.accent.withValues(alpha: 0.1),
              trackHeight: 6,
            ),
            child: Slider(
              min: 1,
              max: 7,
              divisions: 6,
              value: _symptomFrequency,
              onChanged: (v) => setState(() => _symptomFrequency = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1', style: Theme.of(context).textTheme.bodySmall),
                Text('7', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Triggers
  Widget _buildTriggersStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Vaše spúšťače',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Vyberte potraviny, ktoré vám zvyčajne škodia.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: UserProfile.triggerLabels.entries.map((entry) {
              final isSelected = _selectedTriggers.contains(entry.key);
              return FilterChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTriggers.add(entry.key);
                    } else {
                      _selectedTriggers.remove(entry.key);
                    }
                  });
                },
                selectedColor: AppColors.accent,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Step 4: Goals + Allergies
  Widget _buildGoalsAndAllergiesStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Vaše ciele',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Čo chcete dosiahnuť?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: UserProfile.goalLabels.entries.map((entry) {
              final isSelected = _selectedGoals.contains(entry.key);
              return FilterChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedGoals.add(entry.key);
                    } else {
                      _selectedGoals.remove(entry.key);
                    }
                  });
                },
                selectedColor: AppColors.accent,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Alergie & intolerancie',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Voliteľné – pomôže nám filtrovať jedlá.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: UserProfile.allergyLabels.entries.map((entry) {
              final isSelected = _selectedAllergies.contains(entry.key);
              return FilterChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAllergies.add(entry.key);
                    } else {
                      _selectedAllergies.remove(entry.key);
                    }
                  });
                },
                selectedColor: AppColors.riskMedium,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

