import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _navigationTimer = Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.language);
        }
      },
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.psychology_alt,
              size: 90,
              color: AppColors.primary,
            ),

            const SizedBox(height: 25),

            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              AppStrings.tagline,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(),

          ],
        ),
      ),
    );
  }
}