import 'package:flutter_test/flutter_test.dart';
import 'package:yaadsaathi_app/features/games/models/sequence_puzzle.dart';

void main() {
  test('generates a different sequence for the next round', () {
    final generator = SequencePuzzleGenerator();
    final first = generator.next();
    final second = generator.next();

    expect(second.answer, isNot(equals(first.answer)));
    expect(first.choices.toSet(), first.answer.toSet());
    expect(second.choices.toSet(), second.answer.toSet());
  });
}