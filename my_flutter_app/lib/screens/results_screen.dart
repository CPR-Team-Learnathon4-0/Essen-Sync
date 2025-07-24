import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ResultsScreen extends StatelessWidget {
  final TrainingResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Training Complete!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getOverallPerformance(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Results Cards
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Score
                        _buildResultCard(
                          'Final Score',
                          result.score.toString(),
                          Icons.star,
                          Colors.amber.shade600,
                        ),
                        const SizedBox(height: 16),
                        
                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Compressions',
                                result.totalCompressions.toString(),
                                Icons.touch_app,
                                Colors.blue.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Best Streak',
                                result.streak.toString(),
                                Icons.trending_up,
                                Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Average Rate',
                                '${result.averageRate.toInt()} BPM',
                                Icons.speed,
                                _getRateColor(result.averageRate),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Depth Accuracy',
                                '${(result.depthAccuracy * 100).toInt()}%',
                                Icons.vertical_align_center,
                                _getAccuracyColor(result.depthAccuracy),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Feedback Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb, color: Colors.blue.shade600),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Improvement Tips',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ..._getImprovementTips().map(
                                (tip) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '• $tip',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back to Home'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Go back to training screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Train Again'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getOverallPerformance() {
    final scorePercent = (result.score / (result.totalCompressions * 10)) * 100;
    if (scorePercent >= 80) return 'Excellent Performance!';
    if (scorePercent >= 60) return 'Good Performance!';
    if (scorePercent >= 40) return 'Keep Practicing!';
    return 'Room for Improvement';
  }

  Color _getRateColor(double rate) {
    if (rate >= 100 && rate <= 120) return Colors.green.shade600;
    return Colors.orange.shade600;
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green.shade600;
    if (accuracy >= 0.6) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  List<String> _getImprovementTips() {
    List<String> tips = [];
    
    if (result.averageRate < 100) {
      tips.add('Try to compress faster - aim for 100-120 compressions per minute');
    } else if (result.averageRate > 120) {
      tips.add('Slow down slightly - maintain 100-120 compressions per minute');
    }
    
    if (result.depthAccuracy < 0.7) {
      tips.add('Focus on consistent compression depth (5-6 cm)');
    }
    
    if (result.streak < 10) {
      tips.add('Work on maintaining consistent rhythm and depth');
    }
    
    if (tips.isEmpty) {
      tips.add('Great job! Continue practicing to maintain your skills');
    }
    
    tips.add('Consider taking a certified CPR course for hands-on training');
    
    return tips;
  }
}

// Results History Screen
class ResultsHistoryScreen extends StatelessWidget {
  const ResultsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training History'),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<TrainingResult>>(
        future: StorageService.getTrainingResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final results = snapshot.data ?? [];
          
          if (results.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No training sessions yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Complete a training session to see your results here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[results.length - 1 - index]; // Reverse order
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade600,
                    child: Text(
                      result.score.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Training Session',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${result.totalCompressions} compressions • ${result.averageRate.toInt()} BPM\n'
                    '${(result.depthAccuracy * 100).toInt()}% depth accuracy • Streak: ${result.streak}',
                  ),
                  trailing: Text(
                    '${result.date.day}/${result.date.month}/${result.date.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(result: result),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 