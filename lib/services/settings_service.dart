import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _soundKey = 'sound_enabled';
  static const String _hapticsKey = 'haptics_enabled';

  Future<(bool sound, bool haptics)> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sound = prefs.getBool(_soundKey);
      final haptics = prefs.getBool(_hapticsKey);
      return (
        sound ?? true, // default on
        haptics ?? true, // default on
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
      return (true, true);
    }
  }

  Future<void> setSoundEnabled(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundKey, value);
    } catch (e) {
      debugPrint('Error saving sound setting: $e');
    }
  }

  Future<void> setHapticsEnabled(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticsKey, value);
    } catch (e) {
      debugPrint('Error saving haptics setting: $e');
    }
  }
}
