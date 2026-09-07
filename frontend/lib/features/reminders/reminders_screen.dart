import 'package:flutter/material.dart';

import '../../shared/services/reminder_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<ReminderItem> _reminders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final list = await ReminderService.getMyReminders();
      if (!mounted) return;
      setState(() {
        _reminders = list;
        _isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Reminders could not be loaded from the server.';
      });
    }
  }

  Future<void> _acknowledgeReminder(int index) async {
    final target = _reminders[index];
    // Optimistic UI update
    setState(() {
      _reminders[index] = target.copyWith(isCompleted: true);
    });

    try {
      await ReminderService.completeReminder(target.id);
    } catch (_) {
      // Rollback on failure
      if (!mounted) return;
      setState(() {
        _reminders[index] = target.copyWith(isCompleted: false);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not complete reminder. Please try again.')),
      );
    }
  }

  IconData _iconForText(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('medicine') || lower.contains('pill') || lower.contains('dose')) {
      return Icons.medication;
    }
    if (lower.contains('call') || lower.contains('phone')) {
      return Icons.phone;
    }
    return Icons.wb_sunny;
  }

  String _formatTime(String scheduledTime) {
    try {
      final dt = DateTime.parse(scheduledTime).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return 'Today at $hour:$minute $period';
    } catch (_) {
      return scheduledTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 52),
                        const SizedBox(height: 14),
                        Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 14),
                        ElevatedButton(onPressed: _loadReminders, child: const Text('Try again')),
                      ],
                    ),
                  ),
                )
          : _reminders.isEmpty
              ? const Center(
                  child: Text(
                    'No scheduled reminders.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = _reminders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(_iconForText(reminder.text), size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reminder.text,
                                    style: const TextStyle(fontSize: 21),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatTime(reminder.scheduledTime),
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: reminder.isCompleted
                                  ? null
                                  : () => _acknowledgeReminder(index),
                              child: Text(reminder.isCompleted ? 'Okay' : 'Acknowledge'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}