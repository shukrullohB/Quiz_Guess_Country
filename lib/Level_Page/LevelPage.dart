import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  final int level;
  final String question;

  const LevelPage({super.key, required this.level, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Level $level')),
      body: Center(
        child: Text(
          question,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}