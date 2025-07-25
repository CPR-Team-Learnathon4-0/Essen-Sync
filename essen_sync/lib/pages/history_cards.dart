import 'package:flutter/material.dart';

class HistoryCardsPage extends StatelessWidget {
  const HistoryCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> history = [
      {'date': '25 July 2025', 'rate': '110 cpm'},
      {'date': '20 July 2025', 'rate': '98 cpm'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          var item = history[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("Date: ${item['date']}"),
              subtitle: Text("Rate: ${item['rate']}"),
            ),
          );
        },
      ),
    );
  }
}
