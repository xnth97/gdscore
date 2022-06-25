import 'package:flutter/material.dart';
import 'package:gdscore/model/history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史'),
      ),
      body: ListView.builder(
          itemCount: HistoryModel().history.length,
          itemBuilder: (context, index) {
            final round = HistoryModel().history[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    round.left,
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(round.right,
                      style: const TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold)),
                  const Spacer(),
                ],
              ),
            );
          }),
    );
  }
}
