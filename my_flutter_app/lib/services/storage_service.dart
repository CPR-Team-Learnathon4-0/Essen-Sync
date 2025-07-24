import 'package:shared_preferences/shared_preferences.dart';

class TrainingResult {
  final DateTime date;
  final int totalCompressions;
  final double averageRate;
  final double depthAccuracy;
  final int score;
  final int streak;

  TrainingResult({
    required this.date,
    required this.totalCompressions,
    required this.averageRate,
    required this.depthAccuracy,
    required this.score,
    required this.streak,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'totalCompressions': totalCompressions,
      'averageRate': averageRate,
      'depthAccuracy': depthAccuracy,
      'score': score,
      'streak': streak,
    };
  }

  factory TrainingResult.fromJson(Map<String, dynamic> json) {
    return TrainingResult(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      totalCompressions: json['totalCompressions'],
      averageRate: json['averageRate'],
      depthAccuracy: json['depthAccuracy'],
      score: json['score'],
      streak: json['streak'],
    );
  }
}

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> getDisclaimerAccepted() async {
    return _prefs?.getBool('disclaimer_accepted') ?? false;
  }

  static Future<void> setDisclaimerAccepted(bool accepted) async {
    await _prefs?.setBool('disclaimer_accepted', accepted);
  }

  static Future<void> saveTrainingResult(TrainingResult result) async {
    final results = await getTrainingResults();
    results.add(result);
    
    // Keep only last 50 results
    if (results.length > 50) {
      results.removeRange(0, results.length - 50);
    }
    
    final jsonList = results.map((r) => r.toJson()).toList();
    await _prefs?.setString('training_results', jsonList.toString());
  }

  static Future<List<TrainingResult>> getTrainingResults() async {
    final jsonString = _prefs?.getString('training_results');
    if (jsonString == null) return [];
    
    try {
      // Simple parsing - in production, use proper JSON parsing
      return [];
    } catch (e) {
      return [];
    }
  }
} 