import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _reminders = [
    ('Morning medicine', 'Today at 9:00 AM', Icons.medication),
    ('Call family', 'Today at 6:00 PM', Icons.phone),
  ];
  final _acknowledged = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          final acknowledged = _acknowledged.contains(index);
          return Card(
            margin: const EdgeInsets.only(bottom: 18),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(reminder.$3, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reminder.$1, style: const TextStyle(fontSize: 21)),
                        const SizedBox(height: 8),
                        Text(reminder.$2, style: const TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: acknowledged
                        ? null
                        : () => setState(() => _acknowledged.add(index)),
                    child: Text(acknowledged ? 'Okay' : 'Acknowledge'),
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