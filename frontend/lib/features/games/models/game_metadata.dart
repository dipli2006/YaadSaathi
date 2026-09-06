enum GameCategory { memory, sequence, association }

class GameMetadata {
  const GameMetadata({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.difficulty,
    required this.instructions,
  });

  final String id;
  final String name;
  final GameCategory category;
  final String description;
  final String difficulty;
  final String instructions;
}

const availableGames = [
  GameMetadata(
    id: 'memory-match',
    name: 'Memory Match',
    category: GameCategory.memory,
    description: 'Find two cards that belong together.',
    difficulty: 'gentle',
    instructions: 'Turn over two cards and see if they match.',
  ),
  GameMetadata(
    id: 'remember-objects',
    name: 'Remember Objects',
    category: GameCategory.memory,
    description: 'Look carefully and remember familiar objects.',
    difficulty: 'gentle',
    instructions: 'Look at the objects, then choose the ones you remember.',
  ),
  GameMetadata(
    id: 'sequence',
    name: 'Sequence',
    category: GameCategory.sequence,
    description: 'Put things in the right order.',
    difficulty: 'gentle',
    instructions: 'Choose the next item in the sequence.',
  ),
];