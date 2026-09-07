import 'package:flutter/material.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/services/caregiver_service.dart';
import '../../shared/services/memory_service.dart';
import '../../shared/services/reminder_service.dart';

class CaregiverDashboardScreen extends StatefulWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  State<CaregiverDashboardScreen> createState() => _CaregiverDashboardScreenState();
}

class _CaregiverDashboardScreenState extends State<CaregiverDashboardScreen> {
  List<LinkedPatientDetail> _linkedPatients = [];

  @override
  void initState() {
    super.initState();
    _loadLinkedPatients();
  }

  Future<void> _loadLinkedPatients() async {
    final patients = await CaregiverService.getLinkedPatients();
    if (!mounted) return;
    setState(() {
      _linkedPatients = patients;
    });
  }

  String get _patientDisplayName {
    if (_linkedPatients.isNotEmpty && _linkedPatients.first.profile != null) {
      return _linkedPatients.first.profile!.name;
    }
    return AuthService.patientName;
  }

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
                "Here is a calm overview of $_patientDisplayName's recent activity.",
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 24),
              _PatientProfileCard(
                patientName: _patientDisplayName,
                onPressed: () => _showProfile(context),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _DashboardAction(
                      icon: Icons.add_photo_alternate_outlined,
                      label: 'Add memory',
                      onPressed: () => _showAddMemory(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashboardAction(
                      icon: Icons.add_alert_outlined,
                      label: 'Add reminder',
                      onPressed: () => _showAddReminder(context),
                    ),
                  ),
                ],
              ),
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
                    value: 'No data yet',
                    detail: 'Complete a game to see activity',
                  ),
                  _IndicatorCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Hints used',
                    value: 'No data yet',
                    detail: 'Game activity will appear here',
                  ),
                  _IndicatorCard(
                    icon: Icons.schedule,
                    title: 'Recent activity',
                    value: 'No activity yet',
                    detail: 'No sessions recorded',
                  ),
                  _IndicatorCard(
                    icon: Icons.alarm,
                    title: 'Next reminder',
                    value: 'No reminder yet',
                    detail: 'Add one for the patient',
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
                      const _ActivityRow(label: 'No activity recorded yet', time: 'Complete a game to begin tracking'),
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
    final patient = _linkedPatients.isNotEmpty ? _linkedPatients.first : null;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${patient?.profile?.name ?? AuthService.patientName} Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${patient?.email ?? "Linked patient account"}'),
            const SizedBox(height: 8),
            Text('Relationship: ${AuthService.patientRelationship}'),
            if (patient?.profile != null) ...[
              const SizedBox(height: 8),
              Text('Age: ${patient!.profile!.age}'),
              if (patient.profile!.conditionNotes != null) ...[
                const SizedBox(height: 8),
                Text('Notes: ${patient.profile!.conditionNotes}'),
              ],
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Future<void> _showAddMemory(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a trusted memory'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'What should they remember?'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter some details'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await MemoryService.createMemory(
                  title: titleController.text,
                  content: contentController.text,
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (_) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Memory could not be saved. Try again.')),
                  );
                }
              }
            },
            child: const Text('Save memory'),
          ),
        ],
      ),
    );
    titleController.dispose();
    contentController.dispose();
    if (created == true && mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Memory saved for the patient.')),
      );
    }
  }

  Future<void> _showAddReminder(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    if (_linkedPatients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link a patient before adding reminders.')),
      );
      return;
    }
    final titleController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    DateTime scheduledAt = DateTime.now().add(const Duration(hours: 1));
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add a reminder'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Reminder'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a reminder'
                      : null,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.schedule),
                  title: Text(_formatDateTime(scheduledAt)),
                  trailing: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: scheduledAt,
                      );
                      if (date == null || !context.mounted) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(scheduledAt),
                      );
                      if (time != null) {
                        setDialogState(() {
                          scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        });
                      }
                    },
                    child: const Text('Change'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  await ReminderService.createReminder(
                    patientId: _linkedPatients.first.id,
                    text: titleController.text,
                    scheduledTime: scheduledAt,
                  );
                  if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                } catch (_) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Reminder could not be saved. Try again.')),
                    );
                  }
                }
              },
              child: const Text('Save reminder'),
            ),
          ],
        ),
      ),
    );
    titleController.dispose();
    if (created == true && mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Reminder saved for the patient.')),
      );
    }
  }

  String _formatDateTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '${value.day}/${value.month} at $hour:$minute $period';
  }
}

class _DashboardAction extends StatelessWidget {
  const _DashboardAction({required this.icon, required this.label, required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58)),
    );
  }
}

class _PatientProfileCard extends StatelessWidget {
  const _PatientProfileCard({required this.patientName, required this.onPressed});

  final String patientName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.all(20),
        leading: const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 34)),
        title: Text('$patientName profile', style: const TextStyle(fontSize: 21)),
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