import 'package:flutter/material.dart';

import 'core/localization/app_localizations.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/caregiver_login_screen.dart';
import 'features/auth/elderly_login_screen.dart';
import 'features/auth/role_selection_screen.dart';
import 'features/caregiver/caregiver_dashboard_screen.dart';
import 'features/elderly/elderly_home_screen.dart';
import 'features/games/game_selection_screen.dart';
import 'features/language/language_screen.dart';
import 'features/memories/memories_screen.dart';
import 'features/reminders/reminders_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/assistant/talk_screen.dart';
import 'shared/services/locale_service.dart';

void main() {
  runApp(const YaadSaathiApp());
}

class YaadSaathiApp extends StatelessWidget {
  const YaadSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.locale,
      builder: (context, locale, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "YaadSaathi",
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.language: (_) => const LanguageScreen(),
          AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
          AppRoutes.elderlyLogin: (_) => const ElderlyLoginScreen(),
          AppRoutes.elderlyHome: (_) => const ElderlyHomeScreen(),
          AppRoutes.caregiverLogin: (_) => const CaregiverLoginScreen(),
          AppRoutes.caregiverDashboard: (_) => const CaregiverDashboardScreen(),
          AppRoutes.games: (_) => const GameSelectionScreen(),
          AppRoutes.memories: (_) => const MemoriesScreen(),
          AppRoutes.reminders: (_) => const RemindersScreen(),
          AppRoutes.talk: (_) => const TalkScreen(),
        },
      ),
    );
  }
}