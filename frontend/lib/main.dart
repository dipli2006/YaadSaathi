import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

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
      home: const SplashScreen(),
    );
  }
}