import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TrainingGroundPage extends StatefulWidget {
  const TrainingGroundPage({super.key});

  @override
  State<TrainingGroundPage> createState() => _TrainingGroundPageState();
}

class _TrainingGroundPageState extends State<TrainingGroundPage> {
  int compressionCount = 0;
  List<DateTime> timestamps = [];
  double threshold = 3.0; // High sensitivity
  double lastZ = 0.0;
  bool ready = true;

  Timer? cpmTimer;
  int currentCPM = 0;
  int compressionGoal = 30;
  int countdown = 10;
  bool started = false;
  String feedback = "";

  @override
  void initState() {
    super.initState();
    startCountdown();
    startCpmTimer();
    listenToSensor();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          started = true;
        });
        print("🎬 START!");
      } else {
        setState(() {
          countdown--;
        });
        print("⏱️ Countdown: $countdown");
      }
    });
  }

  void listenToSensor() {
    accelerometerEvents.listen((event) {
      if (!started) return;

      double z = event.z;
      double deltaZ = (z - lastZ).abs();
      lastZ = z;

      if (deltaZ > threshold && ready) {
        compressionCount++;
        timestamps.add(DateTime.now());

        if (compressionCount <= compressionGoal) {
          giveFeedback();
        }

        setState(() {});
        ready = false;
        Future.delayed(const Duration(milliseconds: 400), () {
          ready = true;
        });
      }
    });
  }

  void startCpmTimer() {
    cpmTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      DateTime now = DateTime.now();
      timestamps = timestamps.where((t) => now.difference(t).inSeconds < 60).toList();
      setState(() {
        currentCPM = timestamps.length;
      });
      giveFeedback();
    });
  }

  void giveFeedback() {
    if (!started) return;

    if (currentCPM < 90) {
      feedback = "Too Slow! Speed up.";
      print("🔊 Feedback: Slow");
    } else if (currentCPM > 120) {
      feedback = "Too Fast! Slow down.";
      print("🔊 Feedback: Fast");
    } else {
      feedback = "Good! Keep going.";
      print("✅ Feedback: Good");
    }
    setState(() {});
  }

  @override
  void dispose() {
    cpmTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Training Ground")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!started) ...[
              Text("Starting in $countdown...", style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 30),
              const CircularProgressIndicator()
            ] else ...[
              const Text("Chest Compression Training", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Icon(Icons.favorite, color: Colors.red, size: 80),
              Text(
                "Remaining: ${compressionGoal - compressionCount}",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text("Compressions: $compressionCount", style: const TextStyle(fontSize: 24)),
              Text("Current CPM: $currentCPM", style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: feedback.contains("Good") ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
