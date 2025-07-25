import 'package:flutter/material.dart';
import 'learn_cpr.dart';
import 'training_ground.dart';
import 'history_cards.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Essen-Sync Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(context, 'Training Ground', const TrainingGroundPage()),
            _buildCard(context, 'History Cards', const HistoryCardsPage()),
            _buildCard(context, 'Learn CPR', const LearnCprPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
