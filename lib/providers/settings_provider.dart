import 'package:flutter/foundation.dart';
import 'package:ignite_hop/services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _service = SettingsService();

  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  Future<void> load() async {
    final (sound, haptics) = await _service.load();
    _soundEnabled = sound;
    _hapticsEnabled = haptics;
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    notifyListeners();
    await _service.setSoundEnabled(value);
  }

  Future<void> setHapticsEnabled(bool value) async {
    _hapticsEnabled = value;
    notifyListeners();
    await _service.setHapticsEnabled(value);
  }
}
