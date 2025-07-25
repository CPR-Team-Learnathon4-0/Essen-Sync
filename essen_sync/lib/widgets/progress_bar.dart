import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value; // between 0.0 to 1.0

  const ProgressBar({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: Colors.grey[300],
      color: Colors.blue,
      minHeight: 10,
    );
  }
}
