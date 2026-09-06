import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose language')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.translate, size: 72, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose the language that feels most comfortable.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
              const Spacer(),
              _LanguageButton(
                label: 'English',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.roleSelection,
                  arguments: 'en',
                ),
              ),
              const SizedBox(height: 16),
              _LanguageButton(
                label: 'हिंदी',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.roleSelection,
                  arguments: 'hi',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}