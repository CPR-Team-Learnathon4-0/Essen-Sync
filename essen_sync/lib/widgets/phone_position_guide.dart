import 'package:flutter/material.dart';

class PhonePositionGuide extends StatelessWidget {
  const PhonePositionGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.phone_android, size: 80, color: Colors.blue),
        SizedBox(height: 10),
        Text(
          'Place your phone on the dummy’s chest\nface up and stable',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
  