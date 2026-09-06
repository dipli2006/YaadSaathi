import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/caregiver_login_screen.dart';
import 'features/auth/elderly_login_screen.dart';
import 'features/auth/role_selection_screen.dart';
import 'features/caregiver/caregiver_dashboard_screen.dart';
import 'features/elderly/elderly_home_screen.dart';
import 'features/language/language_screen.dart';
import 'features/splash/splash_screen.dart';
import 'shared/widgets/feature_placeholder.dart';

void main() {
  runApp(const YaadSaathiApp());
}

class YaadSaathiApp extends StatelessWidget {
  const YaadSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "YaadSaathi",
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.language: (_) => const LanguageScreen(),
        AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
        AppRoutes.elderlyLogin: (_) => const ElderlyLoginScreen(),
        AppRoutes.elderlyHome: (_) => const ElderlyHomeScreen(),
        AppRoutes.caregiverLogin: (_) => const CaregiverLoginScreen(),
        AppRoutes.caregiverDashboard: (_) => const CaregiverDashboardScreen(),
        AppRoutes.games: (_) => const FeaturePlaceholder(title: 'Games'),
        AppRoutes.memories: (_) => const FeaturePlaceholder(title: 'Memories'),
        AppRoutes.reminders: (_) => const FeaturePlaceholder(title: 'Reminders'),
        AppRoutes.talk: (_) => const FeaturePlaceholder(title: 'Talk'),
      },
    );
  }
}