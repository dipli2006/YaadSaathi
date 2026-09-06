import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Who is using YaadSaathi?')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoleButton(
              icon: Icons.favorite,
              label: 'I am using it for myself',
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.elderlyLogin,
              ),
            ),
            const SizedBox(height: 20),
            _RoleButton(
              icon: Icons.people,
              label: 'I care for someone',
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.caregiverLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 32),
        label: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}