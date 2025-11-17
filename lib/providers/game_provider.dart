import 'package:flutter/foundation.dart';
import 'package:ignite_hop/models/game_state.dart';
import 'package:ignite_hop/services/score_service.dart';

class GameProvider extends ChangeNotifier {
  GameState _state = GameState();
  final ScoreService _scoreService = ScoreService();

  GameState get state => _state;

  Future<void> loadHighScore() async {
    final highScore = await _scoreService.getHighScore();
    _state = _state.copyWith(highScore: highScore);
    notifyListeners();
  }

  void updateScore(int score) {
    _state = _state.copyWith(currentScore: score);
    notifyListeners();
  }

  Future<void> endGame() async {
    _state = _state.copyWith(isGameOver: true, isPlaying: false);

    final isNewHigh = await _scoreService.saveHighScore(_state.currentScore);

    if (isNewHigh) {
      _state = _state.copyWith(highScore: _state.currentScore);
    }

    notifyListeners();
  }

  void startGame() {
    _state = _state.copyWith(
      isPlaying: true,
      isGameOver: false,
      currentScore: 0,
    );
    notifyListeners();
  }

  void resetGame() {
    _state = _state.copyWith(
      isPlaying: false,
      isGameOver: false,
      currentScore: 0,
    );
    notifyListeners();
  }
}
