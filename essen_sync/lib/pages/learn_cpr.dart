import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnCprPage extends StatelessWidget {
  const LearnCprPage({super.key});

  final String videoUrl = 'https://www.youtube.com/watch?v=2G9A3Nojxk8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn CPR")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Instructions:\n\n1. Place hands in center of chest.\n2. Push hard and fast.\n3. Keep doing until help arrives.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(videoUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $videoUrl';
              }
            },
            child: const Text("Watch CPR Tutorial on YouTube"),
          ),
        ],
      ),
    );
  }
}
