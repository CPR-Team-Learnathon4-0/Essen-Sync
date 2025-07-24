import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class AudioService {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _metronomeTimer;
  bool _isMetronomeActive = false;

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(0.8);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void startMetronome({int bpm = 110}) {
    if (_isMetronomeActive) return;
    
    _isMetronomeActive = true;
    final interval = Duration(milliseconds: (60000 / bpm).round());
    
    _metronomeTimer = Timer.periodic(interval, (timer) async {
      if (_isMetronomeActive) {
        // Play a simple beep sound
        // In a real implementation, you would load a beep audio file
        await _playBeep();
      }
    });
  }

  void stopMetronome() {
    _isMetronomeActive = false;
    _metronomeTimer?.cancel();
  }

  Future<void> _playBeep() async {
    // In a real implementation, you would play an actual beep sound file
    // For now, we'll use TTS with a short sound
    await _tts.speak('');
  }

  Future<void> playEncouragement(String type) async {
    switch (type) {
      case 'good_rate':
        await speak('Good pace');
        break;
      case 'too_fast':
        await speak('Slow down');
        break;
      case 'too_slow':
        await speak('Push faster');
        break;
      case 'good_depth':
        await speak('Good depth');
        break;
      case 'too_shallow':
        await speak('Push harder');
        break;
      case 'too_deep':
        await speak('Not so hard');
        break;
      case 'excellent':
        await speak('Excellent compression');
        break;
      case 'start':
        await speak('Begin compressions');
        break;
      case 'complete':
        await speak('Session complete');
        break;
    }
  }

  void dispose() {
    stopMetronome();
    _audioPlayer.dispose();
  }
} 