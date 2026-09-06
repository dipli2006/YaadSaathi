import '../models/game_metadata.dart';

enum GameSessionStep { start, instructions, game, answer, feedback, completion }

class GameSessionController {
  GameSessionController(this.game);

  final GameMetadata game;
  GameSessionStep step = GameSessionStep.start;

  void begin() => step = GameSessionStep.instructions;

  void startGame() => step = GameSessionStep.game;

  void submitAnswer() => step = GameSessionStep.feedback;

  void complete() => step = GameSessionStep.completion;
}