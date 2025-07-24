import 'package:flutter/material.dart';
import 'dart:async';
import '../services/accelerometer_service.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/rate_gauge.dart';
import '../widgets/depth_bar.dart';
import 'results_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final AccelerometerService _accelerometerService = AccelerometerService();
  final AudioService _audioService = AudioService();
  
  // Training session data
  int _totalCompressions = 0;
  int _goodCompressions = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;
  double _currentRate = 0;
  double _currentDepth = 0;
  int _score = 0;
  
  // UI state
  bool _isTraining = false;
  int _remainingTime = 120; // 2 minutes
  Timer? _sessionTimer;
  String _feedbackText = 'Prepare to begin...';
  
  // Feedback tracking
  DateTime _lastFeedbackTime = DateTime.now();
  final Duration _feedbackCooldown = const Duration(seconds: 2);
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _audioService.initialize();
    _accelerometerService.compressionStream.listen(_onCompressionDetected);
  }

  void _startTraining() {
    setState(() {
      _isTraining = true;
      _remainingTime = 120;
      _feedbackText = 'Begin compressions now!';
    });
    
    _accelerometerService.startListening();
    _audioService.startMetronome(bpm: 110);
    _audioService.speak('Begin compressions');
    
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });
      
      if (_remainingTime <= 0) {
        _endTraining();
      }
    });
  }

  void _onCompressionDetected(CompressionData data) {
    if (!_isTraining) return;
    
    setState(() {
      _totalCompressions++;
      _currentRate = data.rate;
      _currentDepth = data.depth;
      
      if (data.isValidCompression) {
        _goodCompressions++;
        _currentStreak++;
        _score += 10 + (_currentStreak > 5 ? 5 : 0); // Bonus for streaks
        
        if (_currentStreak > _bestStreak) {
          _bestStreak = _currentStreak;
        }
      } else {
        _currentStreak = 0;
      }
    });
    
    _updateFeedback(data);
  }

  void _updateFeedback(CompressionData data) {
    final now = DateTime.now();
    if (now.difference(_lastFeedbackTime) < _feedbackCooldown) return;
    
    String feedback = '';
    String audioFeedback = '';
    
    // Rate feedback
    if (data.rate < 100) {
      feedback = 'Push faster';
      audioFeedback = 'too_slow';
    } else if (data.rate > 120) {
      feedback = 'Slow down';
      audioFeedback = 'too_fast';
    } else {
      // Depth feedback
      if (data.depth < 5.0) {
        feedback = 'Push harder';
        audioFeedback = 'too_shallow';
      } else if (data.depth > 6.0) {
        feedback = 'Not so hard';
        audioFeedback = 'too_deep';
      } else {
        feedback = 'Excellent!';
        audioFeedback = 'excellent';
      }
    }
    
    setState(() {
      _feedbackText = feedback;
    });
    
    _audioService.playEncouragement(audioFeedback);
    _lastFeedbackTime = now;
  }

  void _endTraining() {
    _sessionTimer?.cancel();
    _accelerometerService.stopListening();
    _audioService.stopMetronome();
    _audioService.speak('Session complete');
    
    // Save results
    final result = TrainingResult(
      date: DateTime.now(),
      totalCompressions: _totalCompressions,
      averageRate: _currentRate,
      depthAccuracy: _totalCompressions > 0 ? _goodCompressions / _totalCompressions : 0,
      score: _score,
      streak: _bestStreak,
    );
    
    StorageService.saveTrainingResult(result);
    
    // Navigate to results
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Emergency Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade700,
                child: const Text(
                  'In a real emergency, call emergency services (112) immediately',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              
              // Timer and Score Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Time Remaining',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          _score.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Main Training Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Rate and Depth Gauges
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              child: RateGauge(
                                currentRate: _currentRate,
                                targetMin: 100,
                                targetMax: 120,
                              ),
                            ),
                            Expanded(
                              child: DepthBar(
                                currentDepth: _currentDepth,
                                targetMin: 5.0,
                                targetMax: 6.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Feedback Text
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              _feedbackText,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getFeedbackColor(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Compressions: $_totalCompressions | Good: $_goodCompressions | Streak: $_currentStreak',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Start/Stop Button
                      if (!_isTraining)
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _startTraining,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Start Training',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getFeedbackColor() {
    if (_feedbackText.contains('Excellent') || _feedbackText.contains('Good')) {
      return Colors.green.shade600;
    } else if (_feedbackText.contains('faster') || _feedbackText.contains('harder') || 
               _feedbackText.contains('Slow down') || _feedbackText.contains('Not so hard')) {
      return Colors.orange.shade600;
    } else {
      return Colors.black87;
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _accelerometerService.dispose();
    _audioService.dispose();
    super.dispose();
  }
} 