import 'package:flutter/material.dart';

class GamificationElements extends StatelessWidget {
  final int score;

  const GamificationElements({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star, color: Colors.amber),
        SizedBox(width: 8),
        Text(
          'Score: $score',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
