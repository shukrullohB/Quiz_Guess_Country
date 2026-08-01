import 'package:flutter/material.dart';
import 'LevelPage.dart';
import 'levels.dart';

class Level1QuestionPage extends StatefulWidget {
  const Level1QuestionPage({super.key});

  @override
  State<Level1QuestionPage> createState() => _Level1QuestionPageState();
}

class _Level1QuestionPageState extends State<Level1QuestionPage> {
  final String answer = 'MEXICO';
  String userInput = '';

  // Пример фото, замените на свои ассеты
  final List<String> imagePaths = [
    'assets/mexico1.jpg',
    'assets/mexico2.jpg',
    'assets/mexico3.jpg',
    'assets/mexico4.jpg',
  ];

  List<String> get letters {
    // Добавьте лишние буквы для усложнения, если нужно
    return answer.split('')..addAll(['A', 'B', 'D', 'L']);
  }

  void onLetterTap(String letter) {
    if (userInput.length < answer.length) {
      setState(() {
        userInput += letter;
      });
    }
  }

  void onBackspace() {
    if (userInput.isNotEmpty) {
      setState(() {
        userInput = userInput.substring(0, userInput.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 1')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Guess the country by these photos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Image.asset(imagePaths[index], fit: BoxFit.cover);
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              answer.length,
                  (i) => Container(
                width: 32,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 2, color: Colors.black)),
                ),
                child: Center(
                  child: Text(
                    i < userInput.length ? userInput[i] : '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: letters.map((l) {
              return ElevatedButton(
                onPressed: userInput.length < answer.length ? () => onLetterTap(l) : null,
                child: Text(l),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: const Icon(Icons.backspace),
            onPressed: onBackspace,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: userInput == answer
                ? () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LevelPage(level: 2, question: questions[1])),
              );
            }
                : null,
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }
}