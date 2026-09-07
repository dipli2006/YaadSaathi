import 'package:flutter/material.dart';

import '../../shared/services/memory_service.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  late Future<List<MemoryItem>> _memoriesFuture;

  @override
  void initState() {
    super.initState();
    _memoriesFuture = MemoryService.getMyMemories();
  }

  IconData _iconForTitle(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('family') || lower.contains('people')) return Icons.people;
    if (lower.contains('home') || lower.contains('house')) return Icons.home;
    if (lower.contains('celebration') || lower.contains('party')) return Icons.celebration;
    return Icons.local_florist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memories')),
      body: FutureBuilder<List<MemoryItem>>(
        future: _memoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(
              message: 'Memories could not be loaded from the server.',
              onRetry: () => setState(() {
                _memoriesFuture = MemoryService.getMyMemories();
              }),
            );
          }
          final memories = snapshot.data ?? const <MemoryItem>[];
          if (memories.isEmpty) {
            return const Center(
              child: Text(
                'No memories saved yet.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: memories.length,
            itemBuilder: (context, index) {
              final memory = memories[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 18),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  leading: CircleAvatar(
                    radius: 32,
                    child: Icon(_iconForTitle(memory.title), size: 34),
                  ),
                  title: Text(memory.title, style: const TextStyle(fontSize: 22)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(memory.content, style: const TextStyle(fontSize: 17)),
                  ),
                  onTap: () => _showMemory(context, memory.title, memory.content),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showMemory(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Okay')),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 52),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 14),
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}