import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class ElderlyHomeScreen extends StatelessWidget {
  const ElderlyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to YaadSaathi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.05,
          children: [
            _HomeAction(
              icon: Icons.extension,
              label: 'Play',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.games),
            ),
            _HomeAction(
              icon: Icons.photo_library,
              label: 'Memories',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.memories),
            ),
            _HomeAction(
              icon: Icons.alarm,
              label: 'Reminders',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.reminders),
            ),
            _HomeAction(
              icon: Icons.chat_bubble,
              label: 'Talk',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.talk),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}