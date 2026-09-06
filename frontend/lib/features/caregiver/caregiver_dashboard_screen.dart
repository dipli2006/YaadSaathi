import 'package:flutter/material.dart';

import '../../shared/services/auth_service.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 760 ? 2 : 1;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Good morning', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                "Here is a calm overview of ${AuthService.patientName}'s recent activity.",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 24),
              _PatientProfileCard(onPressed: () => _showProfile(context)),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: columns == 2 ? 1.55 : 2.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _IndicatorCard(
                    icon: Icons.check_circle_outline,
                    title: 'Activities completed',
                    value: '4 this week',
                    detail: 'Activity indicator',
                  ),
                  _IndicatorCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Hints used',
                    value: '2 this week',
                    detail: 'Activity indicator',
                  ),
                  _IndicatorCard(
                    icon: Icons.schedule,
                    title: 'Recent activity',
                    value: 'Yesterday',
                    detail: 'Memory Match',
                  ),
                  _IndicatorCard(
                    icon: Icons.alarm,
                    title: 'Next reminder',
                    value: '6:00 PM',
                    detail: 'Call family',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      const _ActivityRow(label: 'Memory Match', time: 'Yesterday at 10:30 AM'),
                      const _ActivityRow(label: 'Remember Objects', time: 'Monday at 4:15 PM'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patient profile'),
        content: const Text('Patient preferences and trusted contacts can be managed here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _PatientProfileCard extends StatelessWidget {
  const _PatientProfileCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.all(20),
        leading: const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 34)),
        title: Text('${AuthService.patientName} profile', style: const TextStyle(fontSize: 21)),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('Preferences and trusted contacts', style: TextStyle(fontSize: 16)),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(detail, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.label, required this.time});

  final String label;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline),
      title: Text(label),
      subtitle: Text(time),
    );
  }
}