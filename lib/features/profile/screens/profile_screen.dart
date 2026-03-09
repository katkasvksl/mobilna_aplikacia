import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../shared/models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _mealReminders = true;
  bool _symptomReminders = true;

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile() ?? UserProfile.empty();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Profil',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Avatar + info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.cardDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withValues(alpha: 0.1),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: AppColors.accent, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name.isNotEmpty ? profile.name : 'Používateľ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _refluxTypeLabel(profile.refluxType),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                      onPressed: () {
                        // Re-do questionnaire
                        context.push('/questionnaire');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Triggers
              if (profile.triggers.isNotEmpty) ...[
                _sectionCard(
                  context,
                  icon: Icons.warning_amber_rounded,
                  title: 'Spúšťače',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.triggers.map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.riskHigh.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          UserProfile.triggerLabels[t] ?? t,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.riskHigh,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Goals
              if (profile.goals.isNotEmpty) ...[
                _sectionCard(
                  context,
                  icon: Icons.flag_outlined,
                  title: 'Ciele',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.goals.map((g) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.riskLow.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          UserProfile.goalLabels[g] ?? g,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.riskLow,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 8),

              // Notifications section
              _settingsSection(context),

              const SizedBox(height: 16),

              // Other settings
              _menuCard(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _settingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _switchTile(
            'Notifikácie',
            Icons.notifications_outlined,
            _notificationsEnabled,
            (v) => setState(() => _notificationsEnabled = v),
          ),
          const Divider(height: 1, indent: 56),
          _switchTile(
            'Pripomienky jedál',
            Icons.restaurant_outlined,
            _mealReminders,
            (v) => setState(() => _mealReminders = v),
          ),
          const Divider(height: 1, indent: 56),
          _switchTile(
            'Pripomienky denníka',
            Icons.book_outlined,
            _symptomReminders,
            (v) => setState(() => _symptomReminders = v),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _menuCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _menuTile('Export PDF', Icons.picture_as_pdf_outlined, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export PDF – čoskoro')),
            );
          }),
          const Divider(height: 1, indent: 56),
          _menuTile('Párovanie hodiniek', Icons.watch_outlined, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Párovanie hodiniek – čoskoro')),
            );
          }),
          const Divider(height: 1, indent: 56),
          _menuTile('Ochrana údajov (GDPR)', Icons.privacy_tip_outlined, () {
            _showGdprDialog(context);
          }),
          const Divider(height: 1, indent: 56),
          _menuTile('Resetovať profil', Icons.refresh, () {
            _showResetDialog(context);
          }),
        ],
      ),
    );
  }

  Widget _menuTile(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 15)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showGdprDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ochrana údajov'),
        content: const SingleChildScrollView(
          child: Text(
            'Vaše dáta sú uložené výhradne lokálne na vašom zariadení. '
            'Žiadne osobné údaje nie sú odosielané na server. '
            'Fotografie jedál sú analyzované prostredníctvom Anthropic Claude API '
            'a nie sú ukladané na ich serveroch. '
            'Môžete kedykoľvek vymazať všetky dáta resetovaním profilu.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Rozumiem'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resetovať profil?'),
        content: const Text(
          'Tým sa vymažú všetky vaše údaje vrátane denníka symptómov. Táto akcia je nevratná.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušiť'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.saveUserProfile(UserProfile.empty());
              if (ctx.mounted) {
                Navigator.pop(ctx);
                GoRouter.of(ctx).go('/onboarding');
              }
            },
            child: const Text('Resetovať', style: TextStyle(color: AppColors.riskHigh)),
          ),
        ],
      ),
    );
  }

  String _refluxTypeLabel(String type) {
    switch (type) {
      case 'GERD':
        return 'Gastroezofágový reflux (GERD)';
      case 'LPR':
        return 'Laryngofaryngálny reflux (LPR)';
      default:
        return 'Iný typ refluxu';
    }
  }
}

