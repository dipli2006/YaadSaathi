import 'package:flutter/material.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  static const _memories = [
    ('Family', 'People who are close to you', Icons.people),
    ('Home', 'A place filled with familiar moments', Icons.home),
    ('Celebrations', 'Special days and happy memories', Icons.celebration),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memories')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _memories.length,
        itemBuilder: (context, index) {
          final memory = _memories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: CircleAvatar(
                radius: 32,
                child: Icon(memory.$3, size: 34),
              ),
              title: Text(memory.$1, style: const TextStyle(fontSize: 22)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(memory.$2, style: const TextStyle(fontSize: 17)),
              ),
              onTap: () => _showMemory(context, memory.$1),
            ),
          );
        },
      ),
    );
  }

  void _showMemory(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Your trusted caregiver can add photos and details here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Okay')),
        ],
      ),
    );
  }
}