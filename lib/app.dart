import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/onboarding/screens/questionnaire_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/meal_plan/screens/meal_plan_screen.dart';
import 'features/meal_plan/screens/meal_detail_screen.dart';
import 'features/food_scanner/screens/scanner_screen.dart';
import 'features/food_scanner/screens/scan_result_screen.dart';
import 'features/food_search/screens/food_search_screen.dart';
import 'features/symptom_diary/screens/diary_screen.dart';
import 'features/symptom_diary/screens/add_entry_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

class RefluxCareApp extends StatelessWidget {
  const RefluxCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RefluxCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      locale: const Locale('sk'),
    );
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final onboardingDone = StorageService.isOnboardingCompleted();
    final isOnboarding = state.matchedLocation == '/onboarding' ||
        state.matchedLocation == '/questionnaire';

    if (!onboardingDone && !isOnboarding) {
      return '/onboarding';
    }
    return null;
  },
  routes: [
    // Onboarding routes (outside shell)
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/questionnaire',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const QuestionnaireScreen(),
    ),
    // Scanner (full screen, outside shell)
    GoRoute(
      path: '/scanner',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/scan-result',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ScanResultScreen(
        imageBytes: state.extra as Uint8List?,
      ),
    ),
    // Detail routes (outside shell for full-screen experience)
    GoRoute(
      path: '/meal-detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => MealDetailScreen(
        foodId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/add-symptom',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final initialNote = state.uri.queryParameters['initialNote'];
        return AddEntryScreen(initialNote: initialNote);
      },
    ),
    GoRoute(
      path: '/food-search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FoodSearchScreen(),
    ),
    // Main shell with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => _ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/meal-plan',
          builder: (context, state) => const MealPlanScreen(),
        ),
        GoRoute(
          path: '/diary',
          builder: (context, state) => const DiaryScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNav({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/meal-plan')) return 1;
    if (location.startsWith('/diary')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/meal-plan');
        break;
      case 2:
        context.push('/scanner');
        break;
      case 3:
        context.go('/diary');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
