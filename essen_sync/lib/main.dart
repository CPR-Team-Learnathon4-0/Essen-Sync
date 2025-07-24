import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(EssenSyncApp());
}

class EssenSyncApp extends StatefulWidget {
  @override
  _EssenSyncAppState createState() => _EssenSyncAppState();
}

class _EssenSyncAppState extends State<EssenSyncApp> {
  String rotationStatus = "Stable";

  @override
  void initState() {
    super.initState();

    gyroscopeEvents.listen((GyroscopeEvent event) async {
      if (event.x.abs() > 2.0 || event.y.abs() > 2.0 || event.z.abs() > 2.0) {
        setState(() {
          rotationStatus = "Rotated!";
        });

        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 200);
        }
      } else {
        setState(() {
          rotationStatus = "Stable";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essen-Sync',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Essen-Sync")),
        body: Center(
          child: Text(
            "Phone Status: $rotationStatus",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
