import 'package:flutter/material.dart';

class FeedbackDisplay extends StatelessWidget {
  final String feedback;

  const FeedbackDisplay({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      feedback,
      style: TextStyle(
        fontSize: 24,
        color: feedback == 'Good' ? Colors.green : Colors.red,
      ),
    );
  }
}
