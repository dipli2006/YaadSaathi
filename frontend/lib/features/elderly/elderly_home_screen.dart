import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/north_india_motif.dart';

class ElderlyHomeScreen extends StatelessWidget {
  const ElderlyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NorthIndiaMotif(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 34, 20, 24),
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.peacock,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.local_florist, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YaadSaathi',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                      Text('Apno ki yaadon ka saathi', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Namaste, welcome home',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A gentle place for your memories, games, and everyday moments.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.peacock,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wb_sunny_outlined, color: AppColors.marigold, size: 34),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Aaj ka din achha hoga. Shall we begin?',
                        style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.05,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _HomeAction(
                    icon: Icons.music_note,
                    label: 'Play',
                    accent: AppColors.primary,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.games),
                  ),
                  _HomeAction(
                    icon: Icons.local_florist,
                    label: 'Memories',
                    accent: AppColors.indigo,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.memories),
                  ),
                  _HomeAction(
                    icon: Icons.wb_sunny,
                    label: 'Reminders',
                    accent: AppColors.secondary,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.reminders),
                  ),
                  _HomeAction(
                    icon: Icons.record_voice_over,
                    label: 'Talk',
                    accent: AppColors.peacock,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.talk),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 29,
              backgroundColor: accent.withValues(alpha: 0.14),
              child: Icon(icon, size: 38, color: accent),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}