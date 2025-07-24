import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class CompressionData {
  final double rate;
  final double depth;
  final bool isValidCompression;
  final DateTime timestamp;

  CompressionData({
    required this.rate,
    required this.depth,
    required this.isValidCompression,
    required this.timestamp,
  });
}

class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final StreamController<CompressionData> _compressionController = 
      StreamController<CompressionData>.broadcast();

  // Compression detection variables
  final List<double> _accelerometerBuffer = [];
  final List<DateTime> _compressionTimes = [];
  final int _bufferSize = 20;
  double _lastPeakValue = 0;
  DateTime _lastCompressionTime = DateTime.now();
  bool _isCompressing = false;
  double _currentDepth = 0;

  // Calibration values
  static const double _minCompressionForce = 8.0; // m/s²
  static const double _maxCompressionForce = 15.0; // m/s²
  static const double _targetMinDepth = 5.0; // cm
  static const double _targetMaxDepth = 6.0; // cm

  Stream<CompressionData> get compressionStream => _compressionController.stream;

  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _processAccelerometerData(event);
    });
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _compressionController.close();
  }

  void _processAccelerometerData(AccelerometerEvent event) {
    // Calculate magnitude of acceleration
    final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    // Apply low-pass filter
    final filteredMagnitude = _applyLowPassFilter(magnitude);
    
    // Detect compression peaks
    final compressionDetected = _detectCompression(filteredMagnitude);
    
    if (compressionDetected) {
      final now = DateTime.now();
      _compressionTimes.add(now);
      
      // Keep only recent compressions (last 30 seconds)
      _compressionTimes.removeWhere((time) => 
          now.difference(time).inSeconds > 30);
      
      // Calculate rate (compressions per minute)
      final rate = _calculateCompressionRate();
      
      // Estimate depth based on acceleration magnitude
      final depth = _estimateCompressionDepth(filteredMagnitude);
      
      // Determine if compression meets quality criteria
      final isValid = _isValidCompression(rate, depth);
      
      _compressionController.add(CompressionData(
        rate: rate,
        depth: depth,
        isValidCompression: isValid,
        timestamp: now,
      ));
    }
  }

  double _applyLowPassFilter(double value) {
    _accelerometerBuffer.add(value);
    
    if (_accelerometerBuffer.length > _bufferSize) {
      _accelerometerBuffer.removeAt(0);
    }
    
    // Simple moving average filter
    if (_accelerometerBuffer.isEmpty) return value;
    
    final sum = _accelerometerBuffer.reduce((a, b) => a + b);
    return sum / _accelerometerBuffer.length;
  }

  bool _detectCompression(double magnitude) {
    final now = DateTime.now();
    
    // Minimum time between compressions (300ms = 200 BPM max)
    if (now.difference(_lastCompressionTime).inMilliseconds < 300) {
      return false;
    }
    
    // Detect significant acceleration indicating compression start
    if (!_isCompressing && magnitude > _minCompressionForce) {
      _isCompressing = true;
      _lastPeakValue = magnitude;
      return false;
    }
    
    // Detect compression release (deceleration)
    if (_isCompressing && magnitude < _minCompressionForce * 0.7) {
      _isCompressing = false;
      _lastCompressionTime = now;
      _currentDepth = _lastPeakValue;
      return true;
    }
    
    // Update peak value during compression
    if (_isCompressing && magnitude > _lastPeakValue) {
      _lastPeakValue = magnitude;
    }
    
    return false;
  }

  double _calculateCompressionRate() {
    if (_compressionTimes.length < 2) return 0;
    
    final now = DateTime.now();
    final recentCompressions = _compressionTimes.where((time) => 
        now.difference(time).inSeconds <= 15).toList();
    
    if (recentCompressions.length < 2) return 0;
    
    final timeSpan = recentCompressions.last.difference(recentCompressions.first);
    if (timeSpan.inMilliseconds == 0) return 0;
    
    final rate = (recentCompressions.length - 1) * 60000 / timeSpan.inMilliseconds;
    return rate.clamp(0, 200); // Reasonable bounds
  }

  double _estimateCompressionDepth(double magnitude) {
    // Convert acceleration magnitude to estimated depth
    // This is a simplified model - in reality, this would require calibration
    final normalizedForce = (magnitude - _minCompressionForce) / 
                           (_maxCompressionForce - _minCompressionForce);
    
    final estimatedDepth = _targetMinDepth + 
                          (normalizedForce * (_targetMaxDepth - _targetMinDepth));
    
    return estimatedDepth.clamp(0, 10); // 0-10 cm range
  }

  bool _isValidCompression(double rate, double depth) {
    // AHA Guidelines: 100-120 BPM, 5-6 cm depth
    final rateValid = rate >= 100 && rate <= 120;
    final depthValid = depth >= _targetMinDepth && depth <= _targetMaxDepth;
    
    return rateValid && depthValid;
  }

  void dispose() {
    stopListening();
  }
} 