import 'dart:math';

class SequencePuzzle {
  const SequencePuzzle({required this.answer, required this.choices});

  final List<int> answer;
  final List<int> choices;
}

class SequencePuzzleGenerator {
  SequencePuzzleGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;
  String? _lastAnswer;

  SequencePuzzle next() {
    const patterns = [
      [1, 2, 3, 4],
      [2, 4, 6, 8],
      [3, 6, 9, 12],
      [4, 8, 12, 16],
      [5, 10, 15, 20],
      [10, 20, 30, 40],
    ];
    final available = patterns
        .where((pattern) => pattern.join(',') != _lastAnswer)
        .toList();
    final answer = [...available[_random.nextInt(available.length)]];
    _lastAnswer = answer.join(',');
    final choices = [...answer]..shuffle(_random);
    return SequencePuzzle(answer: answer, choices: choices);
  }
}