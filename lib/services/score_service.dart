import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ScoreService {
  static const String _highScoreKey = 'high_score';

  Future<int> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      debugPrint('Error loading high score: $e');
      return 0;
    }
  }

  Future<bool> saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHigh = await getHighScore();
      if (score > currentHigh) {
        await prefs.setInt(_highScoreKey, score);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving high score: $e');
      return false;
    }
  }

  Future<void> resetHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
    } catch (e) {
      debugPrint('Error resetting high score: $e');
    }
  }
}
