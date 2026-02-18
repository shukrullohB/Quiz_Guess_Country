// lib/all_levels/level1.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../All_Levels/level2.dart';

class Level1QuestionPage extends StatefulWidget {
  const Level1QuestionPage({super.key});

  @override
  State<Level1QuestionPage> createState() => _Level1QuestionPageState();
}

class _Level1QuestionPageState extends State<Level1QuestionPage>
    with SingleTickerProviderStateMixin {
  final String answer = 'MEXICO';
  final TextEditingController _controller = TextEditingController();
  late final ConfettiController _confettiController =
  ConfettiController(duration: const Duration(seconds: 1));
  String userInput = '';
  bool triedWrong = false;
  bool checkedCorrect = false;
  bool hasChecked = false;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  late final Animation<double> _shakeAnimation = Tween<double>(begin: -8, end: 8)
      .chain(CurveTween(curve: Curves.linear))
      .animate(_shakeController);

  final List<String> imagePaths = [
    'images/mexico1.jpg',
    'images/mexico2.jpg',
    'images/mexico3.jpg',
    'images/mexico4.jpg',
  ];

  bool get isCorrect => userInput.toUpperCase() == answer;

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onCheck() {
    setState(() {
      userInput = _controller.text;
      hasChecked = true;
      checkedCorrect = isCorrect;
      triedWrong = !isCorrect;
    });
    if (isCorrect) {
      _confettiController
        ..stop()
        ..play();
    } else {
      _shakeController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
    isCorrect ? Colors.green : triedWrong ? Colors.red : Colors.white;

    const green = Color(0xFF10E17A);
    const dark1 = Color(0xFF1C2340);
    const dark2 = Color(0xFF10182D);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 1'),
        backgroundColor: dark2,
        foregroundColor: green,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [dark1, dark2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: dark2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Guess the country by these photos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: imagePaths.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                imagePaths[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: child,
                            );
                          },
                          child: Text(
                            hasChecked ? userInput.toUpperCase() : '',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: green,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: dark1,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                              const BorderSide(color: green, width: 2),
                            ),
                            labelText: 'Type the country',
                            labelStyle:
                            TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                            hintText: 'Enter your guess',
                            hintStyle:
                            TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                          ),
                          onChanged: (value) {
                            setState(() {
                              userInput = value;
                              hasChecked = false;
                              triedWrong = false;
                              checkedCorrect = false;
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 4,
                            ),
                            onPressed: _onCheck,
                            child: const Text(
                              'Check',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.1,
              numberOfParticles: 25,
              colors: const [
                Colors.green,
                Colors.white,
                Colors.yellow,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: checkedCorrect
          ? FloatingActionButton.extended(
        backgroundColor: Colors.yellowAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Next'),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const Level2QuestionPage(),
            ),
          );
        },
      )
          : null,
    );
  }
}
