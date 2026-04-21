import 'package:flutter/material.dart';

class AnimatedIntroPage extends StatefulWidget {
  const AnimatedIntroPage({
    super.key,
    required this.onCompleted,
    required this.animationsEnabled,
  });

  final VoidCallback onCompleted;
  final bool animationsEnabled;

  @override
  State<AnimatedIntroPage> createState() => _AnimatedIntroPageState();
}

class _AnimatedIntroPageState extends State<AnimatedIntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );

  late final Animation<double> _logoScale = Tween<double>(begin: 0.78, end: 1.0)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
        ),
      );

  late final Animation<double> _logoOpacity =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
        ),
      );

  late final Animation<double> _titleOpacity =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
        ),
      );

  late final Animation<Offset> _titleOffset =
      Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void initState() {
    super.initState();
    _play();
  }

  Future<void> _play() async {
    if (!widget.animationsEnabled) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (mounted) {
        widget.onCompleted();
      }
      return;
    }

    await _controller.forward();
    if (mounted) {
      widget.onCompleted();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF081226), Color(0xFF112647), Color(0xFF0F172A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Opacity(
                    opacity: widget.animationsEnabled ? _logoOpacity.value : 1,
                    child: Transform.scale(
                      scale: widget.animationsEnabled ? _logoScale.value : 1,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22D3EE).withValues(alpha: 0.24),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('images/logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: widget.animationsEnabled
                    ? _titleOpacity
                    : const AlwaysStoppedAnimation(1),
                child: SlideTransition(
                  position: widget.animationsEnabled
                      ? _titleOffset
                      : const AlwaysStoppedAnimation(Offset.zero),
                  child: const Text(
                    'World Explorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
