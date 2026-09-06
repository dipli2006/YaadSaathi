import 'package:flutter/material.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _DashboardCard(
            icon: Icons.person,
            title: 'Patient profile',
            message: 'Patient details will appear here.',
          ),
          _DashboardCard(
            icon: Icons.insights,
            title: 'Activity overview',
            message: 'Activity indicators will appear here.',
          ),
          _DashboardCard(
            icon: Icons.alarm,
            title: 'Reminders',
            message: 'Reminder management will appear here.',
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 36),
        title: Text(title),
        subtitle: Text(message),
      ),
    );
  }
}