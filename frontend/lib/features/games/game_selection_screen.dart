import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import 'memory_match_screen.dart';
import 'models/game_metadata.dart';
import 'remember_objects_screen.dart';
import 'sequence_screen.dart';
import 'services/game_session_controller.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an activity'),
        leading: IconButton(
          onPressed: () => Navigator.popUntil(
            context,
            ModalRoute.withName(AppRoutes.elderlyHome),
          ),
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Home',
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: availableGames.length,
        itemBuilder: (context, index) {
          final game = availableGames[index];
          return _GameCard(game: game);
        },
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final GameMetadata game;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showInstructions(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(_gameIcon(game.category), size: 44),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(game.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(game.description),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    final pageContext = context;
    final controller = GameSessionController(game)..begin();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(game.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(game.instructions, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                controller.startGame();
                Navigator.pop(context);
                if (game.id == 'memory-match') {
                  Navigator.push(
                    pageContext,
                    MaterialPageRoute<void>(
                      builder: (_) => const MemoryMatchScreen(),
                    ),
                  );
                } else if (game.id == 'remember-objects') {
                  Navigator.push(
                    pageContext,
                    MaterialPageRoute<void>(
                      builder: (_) => const RememberObjectsScreen(),
                    ),
                  );
                } else if (game.id == 'sequence') {
                  Navigator.push(
                    pageContext,
                    MaterialPageRoute<void>(
                      builder: (_) => const SequenceScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    SnackBar(content: Text('${game.name} is ready to begin.')),
                  );
                }
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _gameIcon(GameCategory category) {
    switch (category) {
      case GameCategory.memory:
        return Icons.local_florist;
      case GameCategory.sequence:
        return Icons.format_list_numbered;
      case GameCategory.association:
        return Icons.link;
    }
  }
}