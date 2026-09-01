import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RestAlarmService {
  RestAlarmService._();
  static final RestAlarmService instance = RestAlarmService._();

  AudioPlayer? _player;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setPlayerMode(PlayerMode.mediaPlayer);
      _player = player;
      _initialized = true;
    } catch (e) {
      debugPrint('RestAlarmService init error: $e');
    }
  }

  Future<void> playAlarm() async {
    try {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 200), () => HapticFeedback.heavyImpact());
    } catch (_) {}

    if (!_initialized || _player == null) {
      await init();
    }

    try {
      await _player?.stop();
      await _player?.play(AssetSource('audio/rest_over.wav'), volume: 1.0);
    } catch (e) {
      debugPrint('RestAlarmService playback error: $e');
    }
  }

  Future<void> stopAlarm() async {
    try {
      await _player?.stop();
    } catch (_) {}
  }
}
