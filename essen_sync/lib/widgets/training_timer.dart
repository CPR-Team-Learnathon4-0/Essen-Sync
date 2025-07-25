import 'package:flutter/material.dart';
import 'dart:async';

class TrainingTimer extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onTimerComplete;

  const TrainingTimer({
    Key? key,
    required this.totalSeconds,
    required this.onTimerComplete,
  }) : super(key: key);

  @override
  _TrainingTimerState createState() => _TrainingTimerState();
}

class _TrainingTimerState extends State<TrainingTimer> {
  late int secondsLeft;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.totalSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (secondsLeft == 0) {
        widget.onTimerComplete();
        t.cancel();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time Left: $secondsLeft s',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
